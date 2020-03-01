Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 529DC174CCF
	for <lists+kvm@lfdr.de>; Sun,  1 Mar 2020 11:48:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725874AbgCAKr1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 1 Mar 2020 05:47:27 -0500
Received: from mout.web.de ([212.227.17.12]:53117 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725768AbgCAKr1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 1 Mar 2020 05:47:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1583059641;
        bh=pbGUHoBnmA4VuXlDPPzyVcP8OD3O479cR/YOEJ46juI=;
        h=X-UI-Sender-Class:From:Subject:To:Cc:Date;
        b=YMulo9HQM14+ftYi8xSkIj0mkxLCUFxRdTsMGpt8vR02RT5ySOpB7Ifm/mbxJRhOh
         Gf+M1jcl2sWY+M65C+xhHdCBghUyc8YlXoxSarNi47xKHXJYHKTRg5bm1gxrCAwrTZ
         SNKOubzdf3mK/1GlvwX2Fkw3vNexy+9vZYg+5itg=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.10] ([95.157.55.156]) by smtp.web.de (mrweb101
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0MgOL4-1imxep2JPC-00Nf3C; Sun, 01
 Mar 2020 11:47:21 +0100
From:   Jan Kiszka <jan.kiszka@web.de>
Subject: [PATCH] kvm: x86: Make traced and returned value of kvm_cpuid
 consistent again
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>
Cc:     Jim Mattson <jmattson@google.com>
Message-ID: <dd33df29-2c17-2dc8-cb8f-56686cd583ad@web.de>
Date:   Sun, 1 Mar 2020 11:47:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:HxMoFGOh6TiuImyrnisXPXwHn70wC7IfcNh7MkjvXS7e96GO48a
 es59+YtHounf85c+aGVoI5CUCP5u6Xrk+HJrRZZ/aHH4K32qc40RvB173p0AcaTP2jciHxv
 h3G8OrRVaMNm9PXgWn9LHDMSQN0WJWPcgY/7OzcQ1AnF99+sg6M9tvW7fdSjdd5WK1dnr17
 lGwz1FzDhQh/PHTf+MM0w==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:zyUzPeII2uI=:QxHeME/lCa4F4xafCThg6g
 pvEJ5kM7/yIIMGZbkUd/xkkBc4u9Fd04Lt4z/pBE3yOCWlqH5r4Or5I+EIzh8O8Rqx2CQWREE
 1Vl74r6B+0xRxfbT4dkSBkLcPXZu6pM8GHspNnI4jHVl7+/x4nE3vp1gorG7jGUQrNODZC7p6
 Nes79QChRkwh14jGZONLaa3PeuIsEsuvo8gmWqrd7n7bHu5eDGQh04lElJY39Z9qa8RergRTU
 kTIx3e1nypNW96VPBMlGlGvCKYBAyaMWqy6gMbQxkCoImbC+xN8uRHWh50n/ULp7wf8fkouTP
 SiVPxRKzylPj7x0f+Z/n9UxCagnUrorHK4vo4LyGHo+kKWKf3VrTd/59MWQxpuieQgCV8IxTP
 YXET7wlMrDd0SBPqeasFnub1mFpSwZNAhGdJkhRiBJ030PKfXpLySlIbaImCLSwZfkvhYpOyv
 5UBfdhoZEpHy2l9YEXuRGJQucZeI2WzWBAz6sf71wjM4GgSz1+W4XTS+E3qlMQbVw49CU6KUK
 apIZ8KYZqptqsw7dr+l8VwUXxZsSWEKBCQgDnJfxbMMpYT0KxMJZv9ZGXhqYpUTA36kbeZvay
 TZEm3/IbV94/9jy9uWIUrP+aagAXh7e9pb/au51A757+gmTxHMp5Vf9Mjy64tk0TK0OC2SXWe
 K874WYjTVnw6AM1y+KkH6FSlu4+lUI3/HGImc++EdG7RkEQBS75lLllTpeJZa/3zNI0A0P4ES
 JtrG03h/BKN/uNPyPsyerhjXdyBrLmQXCHLw/ApLn+nRXF4skWQBP0TO8xfOTVnR1EmkvJNs2
 Z3HsWZE+Ntl/AiAlwWbjRDugCPvhqToPTxftmk50lUjvAsIVxQ8Y+BCuxruI3PZtkpfbQBYGT
 PahIuqnTJv0XGKvG2QxWDfxggQvVQdUPnXC1flyCA6mCtIjCdj++Jwzu31qZDufiQSZ/PNI6Z
 3axqlA4A4AK+w/+Q8ssddzw5oqyfg7KKwGk7vVuo+8ZXlEETeIZ0pUexYee6J0rsroM1BbsiN
 7j8Cq6wEHp7tPBZ9Y6Pz7oYSo/OWi3qx8PPtdNVvUwSejenXuGd5ztyATPhXga+bPZFS8mjCN
 nhb/WYHhtt93LtYFQSmHoARcSRFy6nlVK+n/jiC7BG/AMRUWAxqZ7FklAc59ikrQnEAjL2nre
 9cgcqHDtFs5k75DXiUh4ZLWs73CB3j5g11b9YtluGQhZvMXT8Pg67tOZxpNUCI/HjYVahBkzU
 uHciESX9BWiwBPEFf
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

After 43561123ab37, found is not set correctly in case of leaves 0BH,
1FH, or anything out-of-range. This is currently harmless for the return
value because the only caller evaluating it passes leaf 0x80000008.

However, the trace entry is now misleading due to this inaccuracy. It is
furthermore misleading because it reports the effective function, not
the originally passed one. Fix that as well.

Fixes: 43561123ab37 ("kvm: x86: Improve emulation of CPUID leaves 0BH and =
1FH")
Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
=2D--
 arch/x86/kvm/cpuid.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index b1c469446b07..79a738f313f8 100644
=2D-- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1000,13 +1000,12 @@ static bool cpuid_function_in_range(struct kvm_vcp=
u *vcpu, u32 function)
 bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
 	       u32 *ecx, u32 *edx, bool check_limit)
 {
-	u32 function =3D *eax, index =3D *ecx;
+	u32 orig_function =3D *eax, function =3D *eax, index =3D *ecx;
 	struct kvm_cpuid_entry2 *entry;
 	struct kvm_cpuid_entry2 *max;
 	bool found;

 	entry =3D kvm_find_cpuid_entry(vcpu, function, index);
-	found =3D entry;
 	/*
 	 * Intel CPUID semantics treats any query for an out-of-range
 	 * leaf as if the highest basic leaf (i.e. CPUID.0H:EAX) were
@@ -1049,7 +1048,8 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 =
*ebx,
 			}
 		}
 	}
-	trace_kvm_cpuid(function, *eax, *ebx, *ecx, *edx, found);
+	found =3D entry;
+	trace_kvm_cpuid(orig_function, *eax, *ebx, *ecx, *edx, found);
 	return found;
 }
 EXPORT_SYMBOL_GPL(kvm_cpuid);
=2D-
2.16.4

