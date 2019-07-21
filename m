Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 906D76F394
	for <lists+kvm@lfdr.de>; Sun, 21 Jul 2019 16:02:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbfGUOBp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 21 Jul 2019 10:01:45 -0400
Received: from mout.web.de ([212.227.17.12]:59215 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726405AbfGUOBp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 21 Jul 2019 10:01:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1563717697;
        bh=fiBuX9DTmAb+5ikpzDMNF9p/MivqxFw4CMiE7TO6dFs=;
        h=X-UI-Sender-Class:To:Cc:From:Subject:Date;
        b=LftHvd1cEUu8G/4rz0WO+N0zco/y4lqIPAwNouOdrrcxSNTU0Tkm8M1+Lx9mwVoSY
         djo7gBlIjn/k9Xv6cL+yr73V0NcXk7wI+u8Re1ay0E+2OCzgog6r2hg9Fed3wtQsAl
         +axlIAHcLZzdU9z+vM8v1J6F+rktDobYPgSWe4c0=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.10] ([95.157.55.156]) by smtp.web.de (mrweb103
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0Maaur-1i9DIW1aiP-00K8hZ; Sun, 21
 Jul 2019 16:01:37 +0200
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>
Cc:     Liran Alon <liran.alon@oracle.com>
From:   Jan Kiszka <jan.kiszka@web.de>
Subject: [PATCH] KVM: nVMX: Set cached_vmcs12 and cached_shadow_vmcs12 NULL
 after free
Message-ID: <e48af3c7-c7ac-87b4-3ce1-9b7b775cd6f2@web.de>
Date:   Sun, 21 Jul 2019 16:01:36 +0200
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12)
 Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:fMtbULnSAQL9Vd9Ux77WwiAU7lkzjUo1te/TBGEd3enLF1Arx36
 GxE2BGfrkexk5LCUvUKN3Bgl/wctree6SV7qkTgrIpRTD2QnY8/ZU8aLVKyXiaXADpLw247
 OVeD379eA5/SSIkIJI8qLAcgAuIU1iksoyOk94m/OaMAWOF480XIyx2GmvCxtUM6JKLEhx3
 HD3BE97rISK5wRxv27PZg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:WrAr7EdlBz4=:ayyGHSOMcqfr74PL9u1y42
 l+yYl4nlEsJJQJSMGSFOrTS96v3U4drXHaJLgZCuzVqHXRr2U+KuZn+Q4c/SIoH+FeUQeb3ik
 +7djGslfQfP4l7cIyq5OH+LICLcZxkJULLnHyUPDtiUyIkPoEzZv9aLn6nnSxWI2FkIQPGfRQ
 fVjsH3P12edjfh301KjarjKSf8B1LDMu8483Dj184XuquxSiVEAoKFYDCHD5/V1+ufqAnaZoa
 lFazjNjsLSqrkHxC0grCYc6UxnfTupRFesEPZCPedknuWeIvtQb8tEMZDrZYPGoXeEe0di+O1
 Z3Cy9Ilv8zK2LmP4QN8hMAT8UIbVA/n1IghwD1Wi18moezygHqt48LPQkj1dqsp2SqQgI2TK5
 AQ0+KV2Xel5112xFagVOEpvUhrAe5jXiJZquhgVtErNabTHgDXOCoCuQVTkN+yo9Kxx1AKy8X
 dH8wTEib8tPKckEV3G+KJR/SgqVvVDJIMO8hiSXJG8ih0AxRqmfRWDtfkbVwpzKpO7Xvb7WaL
 yBs0nehF1VmW8pVmQzsCbcxJvLl5skHuwPs+GqxCnqmvJgCl7gPH/v2F3J36Lqn5fP74rQ1J2
 rN6lmYERJOT73+DFH48DugwXaJyBAZSlGJDxuQuspiw8KAXsxBA6QwraFhQUUYAl2U3NTt/Yn
 fYFdFwQznLDeMeL9gqUXNVwGXFTBGw/KaJi9D2fK9uiYh6pxJ7Hh69qZ7vUJ8JXMa+WE2+MYP
 xnOt/t0dtvYd7/v0+7n6bCqWCa6DhEQ7XaOHum49OPgi9j/BCovZ5AUsMI5lMpeHJP2tba8Ha
 MTlVqfu4PgAcUURXYcEWIeF4vm8q7hup0tp/7lD8NOvJjt6UobhHnK5xrjGfVt2rOrVP/Ljiz
 CNgQDiwZjIGcrHNdqExK7GET8Oe3AHP/93DPTYm+ifzh1LcQVrhMFdo1TP8UyZ6mjijbPqpzq
 QfRJHTEeJiEDHw0hifvz3RUTwqnzbG3eIWEL06xTCe7LYtL1iDYBeUv1hELWr/Jbmqm2+zYnD
 e11iJfBQ8/TiK/eQe4ohfNPdFa/YJTKeWY6E+pQ7lAnnqmvNv9cagZU9E9rHUw5+hmJWs4kNY
 3Orx4xshZvD1lxBHqypTxiy1Tc3OUSpVf7n
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

Shall help finding use-after-free bugs earlier.

Suggested-by: Liran Alon <liran.alon@oracle.com>
Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
=2D--
 arch/x86/kvm/vmx/nested.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 4cdab4b4eff1..ced9fba32598 100644
=2D-- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -234,7 +234,9 @@ static void free_nested(struct kvm_vcpu *vcpu)
 		vmx->vmcs01.shadow_vmcs =3D NULL;
 	}
 	kfree(vmx->nested.cached_vmcs12);
+	vmx->nested.cached_vmcs12 =3D NULL;
 	kfree(vmx->nested.cached_shadow_vmcs12);
+	vmx->nested.cached_shadow_vmcs12 =3D NULL;
 	/* Unpin physical memory we referred to in the vmcs02 */
 	if (vmx->nested.apic_access_page) {
 		kvm_release_page_dirty(vmx->nested.apic_access_page);
=2D-
2.16.4
