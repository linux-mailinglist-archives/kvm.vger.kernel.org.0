Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0AA952A0AD
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 13:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236991AbiEQLpE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 07:45:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236060AbiEQLo7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 07:44:59 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F1584348A;
        Tue, 17 May 2022 04:44:58 -0700 (PDT)
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24HBZAZS028204;
        Tue, 17 May 2022 11:44:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=FrFPIDlR8vdLMHVjr2KLKkUTWnRb+NRTZ3SvXgqy91U=;
 b=ICji+5oUCG8xNQGyggVWzGUcnJ6S1zO4W++Rfr1XBryBlR9po4ijXucDlE4/QL9tECyp
 M0ubnO7S3DzsUAzSnVm0/4nytYBjtA6GWQMsZLwgZvRLqZITSuA1Qi90v7wXEl+tRoZz
 f/ZYj2NtpR8dE9Hdxprv0iTXaeJBEkzursXFK6NLCHZVJd2G/nwAtUV+qMDGdtsU6m+e
 m2dTJXHO7OMGTnJwTmnQPfwODnKMLwhYQiIp5B8ggClRvFbKhY2DwYIs1uJPFEevlNaU
 jjwydpfybHc8cixLI8vP+LIyuNiRyQ89pW9T5C3495zZMepI9Hdxt42s/be3tB0UUkrK nA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g4ayb07vm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 11:44:57 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24HBbOQs005977;
        Tue, 17 May 2022 11:44:57 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g4ayb07v6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 11:44:57 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24HBhsWE021508;
        Tue, 17 May 2022 11:44:55 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04fra.de.ibm.com with ESMTP id 3g2428uaac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 11:44:55 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24HBiq9P55181606
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 11:44:52 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1B125A4040;
        Tue, 17 May 2022 11:44:52 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B8109A4051;
        Tue, 17 May 2022 11:44:51 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.31.104])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 17 May 2022 11:44:51 +0000 (GMT)
Message-ID: <bceaae6a24324cdb72056977fd6bf7916adcc9d7.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v2 1/1] s390x: add migration test for
 storage keys
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Date:   Tue, 17 May 2022 13:44:51 +0200
In-Reply-To: <3ab95d5d553362a686b9526c8b53996dcaf20400.camel@linux.ibm.com>
References: <20220516090702.1939253-1-nrb@linux.ibm.com>
         <20220516090702.1939253-2-nrb@linux.ibm.com>
         <947af627-64e0-486d-18e2-c877bc4c4ba6@linux.ibm.com>
         <3ab95d5d553362a686b9526c8b53996dcaf20400.camel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 8nF7KKss2A9LqHIwdIEEvFxnUojj1Btp
X-Proofpoint-ORIG-GUID: oQvQoo71ji9GZ903T9Omi6ttGKhXIUVV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-17_02,2022-05-17_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 impostorscore=0
 lowpriorityscore=0 bulkscore=0 mlxlogscore=997 mlxscore=0 suspectscore=0
 clxscore=1015 malwarescore=0 phishscore=0 priorityscore=1501 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205170068
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-05-17 at 10:17 +0200, Nico Boehr wrote:
> On Mon, 2022-05-16 at 18:47 +0200, Janis Schoetterl-Glausch wrote:
> > On 5/16/22 11:07, Nico Boehr wrote:

[...]

> > > +               expected_key.val = i * 2;
> > > +
> > > +               /* ignore reference bit */
> > 
> > Why? Are there any implicit references I'm missing?
> 
> Since the PoP specifies (p. 5-122):
> 
> "The record of references provided by the reference
> bit is not necessarily accurate. However, in the major-
> ity of situations, reference recording approximately
> coincides with the related storage reference."
> 
> I don't really see a way to test this properly.
> 
> Maybe I missed something?

No I think you're right, although in practice the reference bits should
match. Or did you observe a mismatch?
