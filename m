Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFB6D4DAEBB
	for <lists+kvm@lfdr.de>; Wed, 16 Mar 2022 12:16:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240971AbiCPLSF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Mar 2022 07:18:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355295AbiCPLSB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Mar 2022 07:18:01 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1934354BD6
        for <kvm@vger.kernel.org>; Wed, 16 Mar 2022 04:16:47 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22GAtDAg026207;
        Wed, 16 Mar 2022 11:15:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=i7lC1j/u2sUqN3sHAeUCMSgUm+fHwtg7q6f2c4Apre0=;
 b=m2X1lv8U9TPohieNsuLEZhQgcls5y5HSty0hHKQIVJ/OqIxgumbLlzZxtKIQ9UxDeYL4
 0LYDaCGYfr7L263YEJmQ7YW16drzyflmJDBykPLyLH/DUDWOvdHBzY0RlAlQTX4p6m4c
 zDtSvZ+ZPKnl1TVCc84ryapStfV7gpt1KtpGeG+yhy2zYIiY8omHYOafUbXtSG/55mlk
 UOjPRbt1TsVpYiF+cw9+D9qC++dA3FJn5z/9wswmWKaMIGFilx9o6L5edEK77VslKnYO
 Pl0i0fB1bhoXkTFnBsVEl6wgSAw0De403Wuwdn23vevzA6gc3BGVsKaghJvpdsZbxtsA ug== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3euejk8dfj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Mar 2022 11:15:56 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22GAtRaT026528;
        Wed, 16 Mar 2022 11:15:55 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3euejk8dex-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Mar 2022 11:15:55 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22GB7Ko3014653;
        Wed, 16 Mar 2022 11:15:53 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma05fra.de.ibm.com with ESMTP id 3erk58qgxq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Mar 2022 11:15:52 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22GBFnWX27263458
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Mar 2022 11:15:49 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B451C52050;
        Wed, 16 Mar 2022 11:15:49 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.15.48])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with SMTP id ED2325204F;
        Wed, 16 Mar 2022 11:15:47 +0000 (GMT)
Date:   Wed, 16 Mar 2022 12:15:35 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     marcandre.lureau@redhat.com, qemu-devel@nongnu.org,
        Peter Maydell <peter.maydell@linaro.org>,
        Dmitry Fleytman <dmitry.fleytman@gmail.com>,
        "open list:Overall KVM CPUs" <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Bin Meng <bin.meng@windriver.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Peter Xu <peterx@redhat.com>,
        Laurent Vivier <laurent@vivier.eu>,
        Yanan Wang <wangyanan55@huawei.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Vikram Garhwal <fnu.vikram@xilinx.com>,
        "open list:virtio-blk" <qemu-block@nongnu.org>,
        David Hildenbrand <david@redhat.com>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Artyom Tarasenko <atar4qemu@gmail.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Huacai Chen <chenhuacai@kernel.org>,
        Eric Farman <farman@linux.ibm.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Greg Kurz <groug@kaod.org>,
        "open list:S390 SCLP-backed..." <qemu-s390x@nongnu.org>,
        "open list:ARM PrimeCell and..." <qemu-arm@nongnu.org>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "open list:PowerPC TCG CPUs" <qemu-ppc@nongnu.org>,
        Alex =?UTF-8?B?QmVubsOpZQ==?= <alex.bennee@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eduardo Habkost <eduardo@habkost.net>,
        "open list:RISC-V TCG CPUs" <qemu-riscv@nongnu.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Philippe =?UTF-8?B?TWF0aGlldS1EYXVkw6k=?= <f4bug@amsat.org>,
        Coiby Xu <Coiby.Xu@gmail.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        =?UTF-8?B?Q8OpZHJpYw==?= Le Goater <clg@kaod.org>,
        Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [PATCH 10/27] Replace config-time define HOST_WORDS_BIGENDIAN
Message-ID: <20220316121535.16631f9c.pasic@linux.ibm.com>
In-Reply-To: <9c101703-6aff-4188-a56a-8114281f75f4@redhat.com>
References: <20220316095308.2613651-1-marcandre.lureau@redhat.com>
        <9c101703-6aff-4188-a56a-8114281f75f4@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: FNo06TseD_FsDZln6hAhlXXvsq9GF577
X-Proofpoint-ORIG-GUID: Fog26UqiLSIm0iBdEUUd_Qdp1Uv0pEYR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-16_03,2022-03-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 mlxlogscore=999 impostorscore=0 phishscore=0 priorityscore=1501
 clxscore=1011 suspectscore=0 bulkscore=0 adultscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203160068
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 16 Mar 2022 11:28:59 +0100
Thomas Huth <thuth@redhat.com> wrote:

> On 16/03/2022 10.53, marcandre.lureau@redhat.com wrote:
> > From: Marc-André Lureau <marcandre.lureau@redhat.com>
> > 
> > Replace a config-time define with a compile time condition
> > define (compatible with clang and gcc) that must be declared prior to
> > its usage. This avoids having a global configure time define, but also
> > prevents from bad usage, if the config header wasn't included before.
> > 
> > This can help to make some code independent from qemu too.
> > 
> > gcc supports __BYTE_ORDER__ from about 4.6 and clang from 3.2.
> > 
> > Signed-off-by: Marc-André Lureau <marcandre.lureau@redhat.com>
> > ---  
> [...]
> > @@ -188,7 +188,7 @@ CPU_CONVERT(le, 64, uint64_t)
> >    * a compile-time constant if you pass in a constant.  So this can be
> >    * used to initialize static variables.
> >    */
> > -#if defined(HOST_WORDS_BIGENDIAN)
> > +#if HOST_BIG_ENDIAN
> >   # define const_le32(_x)                          \
> >       ((((_x) & 0x000000ffU) << 24) |              \
> >        (((_x) & 0x0000ff00U) <<  8) |              \
> > @@ -211,7 +211,7 @@ typedef union {
> >   
> >   typedef union {
> >       float64 d;
> > -#if defined(HOST_WORDS_BIGENDIAN)
> > +#if HOST_BIG_ENDIAN
> >       struct {
> >           uint32_t upper;
> >           uint32_t lower;
> > @@ -235,7 +235,7 @@ typedef union {
> >   
> >   typedef union {
> >       float128 q;
> > -#if defined(HOST_WORDS_BIGENDIAN)
> > +#if HOST_BIG_ENDIAN
> >       struct {
> >           uint32_t upmost;
> >           uint32_t upper;
> > diff --git a/include/qemu/compiler.h b/include/qemu/compiler.h
> > index 0a5e67fb970e..7fdd88adb368 100644
> > --- a/include/qemu/compiler.h
> > +++ b/include/qemu/compiler.h
> > @@ -7,6 +7,8 @@
> >   #ifndef COMPILER_H
> >   #define COMPILER_H
> >   
> > +#define HOST_BIG_ENDIAN (__BYTE_ORDER__ == __ORDER_BIG_ENDIAN__)  
> 
> Why don't you do it this way instead:
> 
> #if __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
> #define HOST_WORDS_BIGENDIAN 1
> #endif
> 
> ... that way you could avoid the churn in all the other files?
> 

I guess "prevents from bad usage, if the config header wasn't included
before" from the commit message is the answer to that question. I agree
that it is more robust. If we keep the #if defined we really can't
differentiate between "not defined because not big-endian" and "not
defined because the appropriate header was not included."
