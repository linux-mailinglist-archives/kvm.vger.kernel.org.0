Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 954F563D49F
	for <lists+kvm@lfdr.de>; Wed, 30 Nov 2022 12:30:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235255AbiK3Laj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 06:30:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235124AbiK3L3t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 06:29:49 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BD232DAB9
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 03:29:44 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AUAg0CZ002896
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 11:29:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=WoyCFzZjZ9s9Z6U+3HQsiUr3tD+JEwzIINNpxhQwNho=;
 b=J2pdQNQiAywRzdixAyyr4AuM/qxeVluyhl7wm2WoZBQG2bHFVWAihmJ5JvIHRLU5wltZ
 N3UctdO9ltdoFIkvUdtwfCtmuAPK99xJzKRcp4e4dCkHxwf6tQT0AjC6OyFKRjJeNHNW
 6brefWb6rVYctyAUx4P2X+WQ5BJzafx8QDtXpZUgIuRQoGSawby6F4ec57Tbor65sLEW
 w+NxN9jLEBIoXZo9DSZihgoBYwd7jLhN55gNez6MQlFeZvbbJl0/SeKbtpOQxVDrFuhl
 T0wIPBfOgKfZEIHSECux2PrQtbhEqDuMsA2cJaT7KAniXTmdZEaPFiIsTM7t4ScoI3FI 4A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m65nbh4j1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 11:29:44 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2AUAoS3B008513
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 11:29:43 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m65nbh4hh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Nov 2022 11:29:43 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AUBKJSe030917;
        Wed, 30 Nov 2022 11:29:41 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 3m3a2hwpxt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Nov 2022 11:29:41 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AUBN8Xw14287602
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Nov 2022 11:23:08 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 16E7C4C044;
        Wed, 30 Nov 2022 11:29:38 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D0B874C040;
        Wed, 30 Nov 2022 11:29:37 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.56])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 30 Nov 2022 11:29:37 +0000 (GMT)
Date:   Wed, 30 Nov 2022 12:29:36 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, nrb@linux.ibm.com, seiden@linux.ibm.com,
        scgl@linux.ibm.com, thuth@redhat.com
Subject: Re: [PATCH v2 1/2] lib: s390x: add PSW and PSW_CUR_MASK macros
Message-ID: <20221130122936.4fb9388c@p-imbrenda>
In-Reply-To: <a20220cb-7584-52d8-d3c1-72d3ac2f3aa3@linux.ibm.com>
References: <20221129094142.10141-1-imbrenda@linux.ibm.com>
        <20221129094142.10141-2-imbrenda@linux.ibm.com>
        <a20220cb-7584-52d8-d3c1-72d3ac2f3aa3@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: jHCvoiUirN1YIbJ5enLlpMBdb-EJPtmn
X-Proofpoint-ORIG-GUID: k2tIkEVXsVFQuVi5YPCzcBTITuBD2ve3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-30_04,2022-11-30_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 mlxscore=0
 bulkscore=0 malwarescore=0 lowpriorityscore=0 phishscore=0 impostorscore=0
 adultscore=0 priorityscore=1501 spamscore=0 clxscore=1015 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211300080
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 29 Nov 2022 15:17:51 +0100
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 11/29/22 10:41, Claudio Imbrenda wrote:
> > Since a lot of code starts new CPUs using the current PSW mask, add two
> > macros to streamline the creation of generic PSWs and PSWs with the
> > current program mask.
> > 
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > ---
> >   lib/s390x/asm/arch_def.h | 4 ++++
> >   1 file changed, 4 insertions(+)
> > 
> > diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> > index 783a7eaa..43137d5f 100644
> > --- a/lib/s390x/asm/arch_def.h
> > +++ b/lib/s390x/asm/arch_def.h
> > @@ -41,6 +41,8 @@ struct psw {
> >   	uint64_t	addr;
> >   };
> >   
> > +#define PSW(m, a) ((struct psw){ .mask = (m), .addr = (uint64_t)(a) })
> > +
> >   struct short_psw {
> >   	uint32_t	mask;
> >   	uint32_t	addr;
> > @@ -321,6 +323,8 @@ static inline uint64_t extract_psw_mask(void)
> >   	return (uint64_t) mask_upper << 32 | mask_lower;
> >   }
> >   
> > +#define PSW_CUR_MASK(addr) PSW(extract_psw_mask(), (addr))  
> 
> This sounds too much like what extract_psw_mask() does.
> So we should agree on a name that states that we receive a PSW and not a 
> PSW mask.
> 
> s/PSW_CUR_MASK/PSW_WITH_CUR_MASK/
> 
> Other than that the code looks fine.

will do

> 
> > +
> >   static inline void load_psw_mask(uint64_t mask)
> >   {
> >   	struct psw psw = {  
> 

