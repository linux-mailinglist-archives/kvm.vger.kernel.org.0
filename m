Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5E19546626
	for <lists+kvm@lfdr.de>; Fri, 10 Jun 2022 13:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347121AbiFJL44 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jun 2022 07:56:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347496AbiFJL4w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jun 2022 07:56:52 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A4136590;
        Fri, 10 Jun 2022 04:56:47 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25A9U1wQ013799;
        Fri, 10 Jun 2022 11:56:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=g5kgbOY/y5zqzsTJnEt+xt393TSPicHZcNITcUnKX9M=;
 b=mcEXZ0WF0S+LoqKcP9LxXYCemtLUXlGyeicWxBDRNcu9Sxx5bGZZXE32hnRECwKFLUej
 K4kvtawVwLVKZZlmj19hVGUVrlMubnau8M2vcfu85ZSscwNz2i+gkop5bomxI9c+zbt5
 LVFZP+ZzXrPYu+C6gPf4fa7ZGZ6RH+m2X2kCTiwmHboE2q3eiSTb/GwztNjpucGz2ya4
 bNbMmIRDb03hcxwOVhhZ5i90fwzrZuUCHyBv9K35KL5kTszabAGc+lPIhEJV1Y/7qYDB
 kEsIEZ/tnIhTXLlHBDKt9UI1aOtFsMb1YR2fsn78mJesk2hIxaC+zgOFByAz524AaDUr ZA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gm3ck2rpp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Jun 2022 11:56:46 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25AB2l3O004770;
        Fri, 10 Jun 2022 11:56:45 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gm3ck2rpc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Jun 2022 11:56:45 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25ABrJ2f027434;
        Fri, 10 Jun 2022 11:56:44 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 3gfy19g6bw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Jun 2022 11:56:43 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25ABuJI221758380
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Jun 2022 11:56:19 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 98A6B4C044;
        Fri, 10 Jun 2022 11:56:40 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 460664C040;
        Fri, 10 Jun 2022 11:56:40 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.15.52])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 10 Jun 2022 11:56:40 +0000 (GMT)
Date:   Fri, 10 Jun 2022 13:56:38 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, thuth@redhat.com, scgl@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v4 1/1] s390x: add migration test for
 storage keys
Message-ID: <20220610135638.2c4f6b1d@p-imbrenda>
In-Reply-To: <2fc9f517-57d0-73ae-3083-26e5dcf05dbb@linux.ibm.com>
References: <20220608131328.6519-1-nrb@linux.ibm.com>
        <20220608131328.6519-2-nrb@linux.ibm.com>
        <2fc9f517-57d0-73ae-3083-26e5dcf05dbb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Fv0ZmTYGhhMBM47M0V65qs5czoeD71Qo
X-Proofpoint-ORIG-GUID: 8moidcYAiB4yOm7T1tM-filF0LihlJDo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-10_05,2022-06-09_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 clxscore=1015 spamscore=0 suspectscore=0 lowpriorityscore=0 adultscore=0
 bulkscore=0 phishscore=0 priorityscore=1501 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206100044
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 10 Jun 2022 10:49:28 +0200
Janosch Frank <frankja@linux.ibm.com> wrote:

[...]

> > +		key_to_set = i * 2;
> > +		set_storage_key(pagebuf[i], key_to_set, 1);
> > +	}
> > +
> > +	puts("Please migrate me, then press return\n");
> > +	(void)getchar();
> > +
> > +	for (i = 0; i < NUM_PAGES; i++) {
> > +		report_prefix_pushf("page %d", i);
> > +
> > +		actual_key.val = get_storage_key(pagebuf[i]);  
> 
> iske is nice but I think it would also be interesting to check if the 
> actual memory protection was carried over. The iske check is enough for 
> now though.

we had that in a previous version, but I think it's overkill, there are
separate tests to check for key protection, I think?

also, under TCG the value of the storage keys is migrated, but there is
no protection, this makes the test unnecessarily complex

[...]
