Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB3F57215F
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 18:50:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233286AbiGLQue (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 12:50:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233117AbiGLQub (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 12:50:31 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C9EBBFAF5;
        Tue, 12 Jul 2022 09:50:31 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26CGYjQq019509;
        Tue, 12 Jul 2022 16:50:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=xjAnb8qlwRMbf2xQ5A62DQEEJAj4/WVGnU3seC1PADg=;
 b=exmFT6HmIUKakoRRMVlqXCNuhsP+pCTbDzysMYKGgthvGrRDy2I77IDmCbwh1fouGJf7
 UJwSejfcLB+fJB5Fh4oZOhRiTmemBNw92JP008EtKeF0sCzG911igWjv6RZuoIbq7oSQ
 o+O+CB3oJkN3LY9KH8Bdb4rIuiGQiQInKtl4pfwut9Md8dtjYYOjTHITMCP+5rP544lg
 f9WRGiVy18a5U/P6ulrKSWSSCr8jZ4UWgNDQrZ9YGXHmhiVifP9BmRySlnQBbMITbwC2
 5GGMDOqW1pEzinAcHWzh7pM4lD+mB3GvYjACcq3j1Ldl1uaMFuSB7YFoFRSJnjMbf2y2 ew== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h9b2fk7sp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jul 2022 16:50:30 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26CFt7ga001859;
        Tue, 12 Jul 2022 16:50:29 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h9b2fk7rw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jul 2022 16:50:29 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26CGLuED025284;
        Tue, 12 Jul 2022 16:50:27 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04fra.de.ibm.com with ESMTP id 3h99s78645-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jul 2022 16:50:27 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26CGoO2514549474
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jul 2022 16:50:24 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2D5C542041;
        Tue, 12 Jul 2022 16:50:24 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AF45F4203F;
        Tue, 12 Jul 2022 16:50:23 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.1.61])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 12 Jul 2022 16:50:23 +0000 (GMT)
Date:   Mon, 11 Jul 2022 15:25:30 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@linux.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Subject: Re: [PATCH 1/1] KVM: s390: Add facility 197 to the white list
Message-ID: <20220711152530.396e44bf@p-imbrenda>
In-Reply-To: <754d4ea2-8a1a-9b09-50c1-f877696b81f2@linux.ibm.com>
References: <20220711115108.6494-1-borntraeger@linux.ibm.com>
        <754d4ea2-8a1a-9b09-50c1-f877696b81f2@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: j62oFqgCUmQ5NWRRomwCgq3fmyeFo6Oa
X-Proofpoint-GUID: SXu__R6_d2Q399bmmKGA2xq-CROozL-U
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-12_10,2022-07-12_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 bulkscore=0 mlxscore=0 priorityscore=1501 impostorscore=0 mlxlogscore=999
 suspectscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207120065
X-Spam-Status: No, score=-0.7 required=5.0 tests=BAYES_00,DATE_IN_PAST_24_48,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 11 Jul 2022 15:11:30 +0200
Christian Borntraeger <borntraeger@linux.ibm.com> wrote:

> Am 11.07.22 um 13:51 schrieb Christian Borntraeger:
> > z16 also provides facility 197 (The processor-activity-instrumentation
> > extension 1). Lets add it to KVM.
> > 
> > Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> > ---
> >   arch/s390/tools/gen_facilities.c | 1 +
> >   1 file changed, 1 insertion(+)
> > 
> > diff --git a/arch/s390/tools/gen_facilities.c b/arch/s390/tools/gen_facilities.c
> > index 530dd941d140..cb0aff5c0187 100644
> > --- a/arch/s390/tools/gen_facilities.c
> > +++ b/arch/s390/tools/gen_facilities.c
> > @@ -111,6 +111,7 @@ static struct facility_def facility_defs[] = {
> >   			193, /* bear enhancement facility */
> >   			194, /* rdp enhancement facility */
> >   			196, /* processor activity instrumentation facility */
> > +			197, /* processor activity instrumentation extension 1 */
> >   			-1  /* END */
> >   		}
> >   	},  
> 
> Unless there are complaints, I will queue this with "white list" -> "allow list" and "lets" -> "let's".

