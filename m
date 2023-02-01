Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16965687023
	for <lists+kvm@lfdr.de>; Wed,  1 Feb 2023 21:54:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231127AbjBAUyK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Feb 2023 15:54:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230417AbjBAUyG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Feb 2023 15:54:06 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C97EACA24
        for <kvm@vger.kernel.org>; Wed,  1 Feb 2023 12:53:42 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 311KpWkg006250
        for <kvm@vger.kernel.org>; Wed, 1 Feb 2023 20:52:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version; s=pp1; bh=PmOG4ax+zhRQwzcmTZLzSEJOFzyRO3zchkC/7mxqxwQ=;
 b=kYY2OhAIY2zcUiTxMNAnqM7Gii0Ex98CD1Do3K7DFhshLH7dvl7x2KI8F1hgGqpTwQCB
 KdWkbUxjiDoWOod6XfGAOaacEyLVZ5ic0RNuTUd7S/703SMqn52KcHtXZl8epG+XR3/Z
 Niv//TrbKKCnu+te7wejBNByOwc9XG4XdRNncvHIxKHMVPjOxRkk+Gk15Ujewh3x+VPR
 XYLOuVN+FSdNjReOQeXj2W4fCdZdXGIsGRMMALg8OLB+eFu86K8vD393eLsDF2wmF+ft
 YSjKQYlSlWKKSLDZIi2Rq4MPWg8mMYf8QPfa8OYVWc3uhIvp/dwE8eq/nkCelHoZ16cL Ow== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nfyg480e1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 01 Feb 2023 20:52:37 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 311KqaMB008238
        for <kvm@vger.kernel.org>; Wed, 1 Feb 2023 20:52:36 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nfyg480dn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Feb 2023 20:52:36 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 311KIKfw014521;
        Wed, 1 Feb 2023 20:52:34 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3ncvtydbh8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Feb 2023 20:52:34 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 311KqU4C51511746
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Feb 2023 20:52:31 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D85F92004D;
        Wed,  1 Feb 2023 20:52:30 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A46E620040;
        Wed,  1 Feb 2023 20:52:30 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.174.183])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed,  1 Feb 2023 20:52:30 +0000 (GMT)
Message-ID: <22ea7ec1a3703b164b039d4a7686a2b5426d24ff.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v2 6/8] s390x: define a macro for the
 stack frame size
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Marc Hartmayer <mhartmay@linux.ibm.com>, kvm@vger.kernel.org
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, Thomas Huth <thuth@redhat.com>
Date:   Wed, 01 Feb 2023 21:52:30 +0100
In-Reply-To: <20230119114045.34553-7-mhartmay@linux.ibm.com>
References: <20230119114045.34553-1-mhartmay@linux.ibm.com>
         <20230119114045.34553-7-mhartmay@linux.ibm.com>
Content-Type: multipart/mixed; boundary="=-ye/idHZM9NOx7BEG6HiU"
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: cRMp5DT_gzEgAc4rPs-rP_haigKZ3dTo
X-Proofpoint-ORIG-GUID: 8-LeZCR4mrHCyhH0ndmC9fsidRIIQ3H3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-01_04,2023-01-31_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 adultscore=0 phishscore=0 malwarescore=0 mlxscore=0
 spamscore=0 suspectscore=0 lowpriorityscore=0 clxscore=1015
 mlxlogscore=999 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2212070000 definitions=main-2302010174
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--=-ye/idHZM9NOx7BEG6HiU
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2023-01-19 at 12:40 +0100, Marc Hartmayer wrote:
> Define and use a macro for the stack frame size.
>=20
> Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>

Reviewed-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
> ---
>  lib/s390x/asm-offsets.c     | 1 +
>  s390x/Makefile              | 2 +-
>  s390x/cstart64.S            | 2 +-
>  s390x/flat.lds.S            | 4 +++-
>  s390x/gs.c                  | 5 +++--
>  s390x/macros.S              | 4 ++--
>  s390x/snippets/c/flat.lds.S | 6 ++++--
>  7 files changed, 15 insertions(+), 9 deletions(-)
>=20
[...]

> diff --git a/s390x/gs.c b/s390x/gs.c
> index 4993eb8f43a9..2c2b972d7e65 100644
> --- a/s390x/gs.c
> +++ b/s390x/gs.c
> @@ -9,6 +9,7 @@
>   *    Janosch Frank <frankja@linux.ibm.com>
>   */
>  #include <libcflat.h>
> +#include <asm/asm-offsets.h>
>  #include <asm/page.h>
>  #include <asm/facility.h>
>  #include <asm/interrupt.h>
> @@ -41,8 +42,8 @@ extern void gs_handler_asm(void);
>  	    "	    aghi    %r15,-320\n" 		/* Allocate stack frame */
One could argue that the macro should be used here also.
320 =3D stack_size + register_save_area + control_block
>  	    "	    stmg    %r0,%r13,192(%r15)\n" 	/* Store regs to save area */
>  	    "	    stg	    %r14,312(%r15)\n"
> -	    "	    la	    %r2,160(%r15)\n" 		/* Store gscb address in this_cb */
> -	    "	    .insn   rxy,0xe30000000049,0,160(%r15)\n" /* stgsc */
> +	    "	    la	    %r2," xstr(STACK_FRAME_SIZE) "(%r15) \n" 		/* Store gs=
cb address in this_cb */
> +	    "	    .insn   rxy,0xe30000000049,0," xstr(STACK_FRAME_SIZE) "(%r15)=
\n" /* stgsc */

The comment indentation is a bit messed up now.

>  	    "	    lg	    %r14,24(%r2)\n" 		/* Get GSEPLA from GSCB*/
>  	    "	    lg	    %r14,40(%r14)\n" 		/* Get GSERA from GSEPL*/
>  	    "	    stg	    %r14,304(%r15)\n" 		/* Store GSERA in r14 of reg save=
 area */

Nothing to do with your changes, but the whitespace in this asm block is pr=
etty messy.
Have a look at the attached patch for some suggestion, but feel free to ign=
ore them.

[...]


--=-ye/idHZM9NOx7BEG6HiU
Content-Disposition: attachment; filename="gs_handler_asm.patch"
Content-Type: text/x-patch; name="gs_handler_asm.patch"; charset="UTF-8"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL3MzOTB4L2dzLmMgYi9zMzkweC9ncy5jCmluZGV4IDJjMmI5NzJkLi45YWU4
OTNlYSAxMDA2NDQKLS0tIGEvczM5MHgvZ3MuYworKysgYi9zMzkweC9ncy5jCkBAIC0zNiwyMiAr
MzYsMjcgQEAgc3RhdGljIGlubGluZSB1bnNpZ25lZCBsb25nIGxvYWRfZ3VhcmRlZCh1bnNpZ25l
ZCBsb25nICpwKQogCiAvKiBndWFyZGVkLXN0b3JhZ2UgZXZlbnQgaGFuZGxlciBhbmQgZmluYWxs
eSBpdCBjYWxscyBnc19oYW5kbGVyICovCiBleHRlcm4gdm9pZCBnc19oYW5kbGVyX2FzbSh2b2lk
KTsKLQlhc20oIi5nbG9ibCBnc19oYW5kbGVyX2FzbVxuIgotCSAgICAiZ3NfaGFuZGxlcl9hc206
XG4iCi0JICAgICIJICAgIGxncgkgICAgJXIxNCwlcjE1XG4iIAkJLyogU2F2ZSBjdXJyZW50IHN0
YWNrIGFkZHJlc3MgaW4gcjE0ICovCi0JICAgICIJICAgIGFnaGkgICAgJXIxNSwtMzIwXG4iIAkJ
LyogQWxsb2NhdGUgc3RhY2sgZnJhbWUgKi8KLQkgICAgIgkgICAgc3RtZyAgICAlcjAsJXIxMywx
OTIoJXIxNSlcbiIgCS8qIFN0b3JlIHJlZ3MgdG8gc2F2ZSBhcmVhICovCi0JICAgICIJICAgIHN0
ZwkgICAgJXIxNCwzMTIoJXIxNSlcbiIKLQkgICAgIgkgICAgbGEJICAgICVyMiwiIHhzdHIoU1RB
Q0tfRlJBTUVfU0laRSkgIiglcjE1KSBcbiIgCQkvKiBTdG9yZSBnc2NiIGFkZHJlc3MgaW4gdGhp
c19jYiAqLwotCSAgICAiCSAgICAuaW5zbiAgIHJ4eSwweGUzMDAwMDAwMDA0OSwwLCIgeHN0cihT
VEFDS19GUkFNRV9TSVpFKSAiKCVyMTUpXG4iIC8qIHN0Z3NjICovCi0JICAgICIJICAgIGxnCSAg
ICAlcjE0LDI0KCVyMilcbiIgCQkvKiBHZXQgR1NFUExBIGZyb20gR1NDQiovCi0JICAgICIJICAg
IGxnCSAgICAlcjE0LDQwKCVyMTQpXG4iIAkJLyogR2V0IEdTRVJBIGZyb20gR1NFUEwqLwotCSAg
ICAiCSAgICBzdGcJICAgICVyMTQsMzA0KCVyMTUpXG4iIAkJLyogU3RvcmUgR1NFUkEgaW4gcjE0
IG9mIHJlZyBzYXZlIGFyZWEgKi8KLQkgICAgIgkgICAgYnJhc2wgICAlcjE0LGdzX2hhbmRsZXJc
biIgCQkvKiBKdW1wIHRvIGdzX2hhbmRsZXIgKi8KLQkgICAgIgkgICAgbG1nCSAgICAlcjAsJXIx
NSwxOTIoJXIxNSlcbiIgCS8qIFJlc3RvcmUgcmVncyAqLwotCSAgICAiCSAgICBhZ2hpICAgICVy
MTQsIDZcbiIgCQkJLyogQWRkIGxnZyBpbnN0ciBsZW4gdG8gR1NFUkEgKi8KLQkgICAgIgkgICAg
YnIJICAgICVyMTRcbiIgCQkJLyogSnVtcCB0byBuZXh0IGluc3RydWN0aW9uIGFmdGVyIGxnZyAq
LwotCSAgICAiCSAgICAuc2l6ZSBnc19oYW5kbGVyX2FzbSwuLWdzX2hhbmRsZXJfYXNtXG4iKTsK
Kwlhc20gKCAgICAgICAgICAiLm1hY3JvCVNUR1NDCWFyZ3M6dmFyYXJnXG4iCisJCSIJLmluc24J
cnh5LDB4ZTMwMDAwMDAwMDQ5LFxcYXJnc1xuIgorCQkiCS5lbmRtXG4iCisJCSIJLmdsb2JsCWdz
X2hhbmRsZXJfYXNtXG4iCisJCSJnc19oYW5kbGVyX2FzbTpcbiIKKwkJIglsZ3IJJXIxNCwlcjE1
XG4iCQkJCS8qIFNhdmUgY3VycmVudCBzdGFjayBhZGRyZXNzIGluIHIxNCAqLworCQkiLkxnc19o
YW5kbGVyX2ZyYW1lID0gMTYqOCszMisiIHhzdHIoU1RBQ0tfRlJBTUVfU0laRSkgIlxuIgorCQki
CWFnaGkJJXIxNSwtKC5MZ3NfaGFuZGxlcl9mcmFtZSlcbiIJCS8qIEFsbG9jYXRlIHN0YWNrIGZy
YW1lICovCisJCSIJc3RtZwklcjAsJXIxMywxOTIoJXIxNSlcbiIJCQkvKiBTdG9yZSByZWdzIHRv
IHNhdmUgYXJlYSAqLworCQkiCXN0ZwklcjE0LDMxMiglcjE1KVxuIgorCQkiCWxhCSVyMiwiIHhz
dHIoU1RBQ0tfRlJBTUVfU0laRSkgIiglcjE1KVxuIgkvKiBTdG9yZSBnc2NiIGFkZHJlc3MgaW4g
dGhpc19jYiAqLworCQkiCVNUR1NDCSVyMCwiIHhzdHIoU1RBQ0tfRlJBTUVfU0laRSkgIiglcjE1
KVxuIgorCQkiCWxnCSVyMTQsMjQoJXIyKVxuIgkJCQkvKiBHZXQgR1NFUExBIGZyb20gR1NDQiov
CisJCSIJbGcJJXIxNCw0MCglcjE0KVxuIgkJCS8qIEdldCBHU0VSQSBmcm9tIEdTRVBMKi8KKwkJ
IglzdGcJJXIxNCwzMDQoJXIxNSlcbiIJCQkvKiBTdG9yZSBHU0VSQSBpbiByMTQgb2YgcmVnIHNh
dmUgYXJlYSAqLworCQkiCWJyYXNsCSVyMTQsZ3NfaGFuZGxlclxuIgkJCS8qIEp1bXAgdG8gZ3Nf
aGFuZGxlciAqLworCQkiCWxtZwklcjAsJXIxNSwxOTIoJXIxNSlcbiIJCQkvKiBSZXN0b3JlIHJl
Z3MgKi8KKwkJIglhZ2hpCSVyMTQsIDZcbiIJCQkJLyogQWRkIGxnZyBpbnN0ciBsZW4gdG8gR1NF
UkEgKi8KKwkJIglicgklcjE0XG4iCQkJCQkvKiBKdW1wIHRvIG5leHQgaW5zdHJ1Y3Rpb24gYWZ0
ZXIgbGdnICovCisJCSIuc2l6ZSBnc19oYW5kbGVyX2FzbSwuLWdzX2hhbmRsZXJfYXNtXG4iCisJ
KTsKIAogdm9pZCBnc19oYW5kbGVyKHN0cnVjdCBnc19jYiAqdGhpc19jYikKIHsK


--=-ye/idHZM9NOx7BEG6HiU--

