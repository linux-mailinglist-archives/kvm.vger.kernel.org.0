Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B3C9528003
	for <lists+kvm@lfdr.de>; Mon, 16 May 2022 10:46:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240524AbiEPIqj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 04:46:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242114AbiEPIqC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 04:46:02 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 596D833C;
        Mon, 16 May 2022 01:46:00 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24G8jdYR024834;
        Mon, 16 May 2022 08:45:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=eMLNwQHNsg2P/SQX0B8htA1tBS0CZJTjRzbyeJk74/s=;
 b=FEGw02aSe4qUEGjHXkcCt7ZN9VGQMoZqT4wfo8y3Q5dOs8YllkZ84Du6JSKw0B2okMio
 zVJDewzRIFguJmax4FK5JQFbMzVAsuIeIBFBUGV7LBpH++gpVCuS8eoTkouUWXpRKQp4
 2MDBxfqEJrI8OVODwXlsW2uATgCTLQslMdkLBxK//1JktH1PuU2whKoSSypj54wqtJf2
 H10x0fLF5KxQdVVSg2nvWqRILU+7ckmhBmMv+sMNly2V6SbtiaC0ZN3DR5whQ6D/vCeK
 8rt49empJepxSpgQ7Cd437rVBBRSiTvj5vW/O74Cr0MdySXAHT5RO7AelteaRe5mRtpe CA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g3kcv0080-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 08:45:59 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24G8jwLY025653;
        Mon, 16 May 2022 08:45:58 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g3kcv007m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 08:45:58 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24G8gd0P019994;
        Mon, 16 May 2022 08:45:57 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma05fra.de.ibm.com with ESMTP id 3g24291sus-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 08:45:56 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24G8jr4q41484684
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 May 2022 08:45:53 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D07DBA405C;
        Mon, 16 May 2022 08:45:53 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7469BA4054;
        Mon, 16 May 2022 08:45:53 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.50.122])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 16 May 2022 08:45:53 +0000 (GMT)
Message-ID: <231dfe7a6e30a25d8790177b868934d5502a0966.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v1 2/2] s390x: add migration test for
 storage keys
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, thuth@redhat.com
Date:   Mon, 16 May 2022 10:45:53 +0200
In-Reply-To: <20220513150404.6d64ae9e@p-imbrenda>
References: <20220512140107.1432019-1-nrb@linux.ibm.com>
         <20220512140107.1432019-3-nrb@linux.ibm.com>
         <5781a3a7-c76c-710d-4236-b82f6e821c48@linux.ibm.com>
         <20220513143323.25ca256a@p-imbrenda>
         <a2e497b3-7d86-280c-f483-9ba20707294b@linux.ibm.com>
         <20220513150404.6d64ae9e@p-imbrenda>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.1 (3.44.1-1.fc36) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: z4jKKn1nHcXKKTq08i3gKzNHmNDrjzPl
X-Proofpoint-GUID: P7IR2QWM_Ry4w7lCprWxXvXvW2vbAmcV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-16_03,2022-05-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 priorityscore=1501
 lowpriorityscore=0 spamscore=0 bulkscore=0 impostorscore=0 mlxscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205160049
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-05-13 at 15:04 +0200, Claudio Imbrenda wrote:
> I think this migration test should be kept more on focus about
> migration

Makes sense to me. In my next version, I will remove this check.
Thanks.
