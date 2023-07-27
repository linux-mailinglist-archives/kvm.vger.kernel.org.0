Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C587476532B
	for <lists+kvm@lfdr.de>; Thu, 27 Jul 2023 14:04:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233663AbjG0ME0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jul 2023 08:04:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232695AbjG0MEZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jul 2023 08:04:25 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54BFC2D4F
        for <kvm@vger.kernel.org>; Thu, 27 Jul 2023 05:04:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
        In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=/V21dYcIz6hMmpT4Ox5noRWqclcNjohwFIALgIDFtq8=; b=Ud37qITVyHsbIXpu0Jl6hd4kRf
        v7vyDlYOQIZTrVKCduk6aAMtb0YqFUHM5Pw9+VFSkni0I/FuxrMdje42HeP6r47JWz3thGYf4zzon
        yIP0D6RjQBe3zPeE86+kzqz1aGuJ5Z7PZ1hUkELHTC/nCltmcGxSlUpN1vko4vSPRdXaSQe8qiUzn
        3XeqtbipHWUpYFlWi1JnEkUx4tQKb3+9na77Me7Oy+JQq2CTMcnq4LJuZK8KoIMj6E9dRwwIitTxv
        w4U8xmTH7DOAQfZAxwcCNxxyano0oVMIuI2cewXj8Zz86zktVhAExBg3Gwk9annmBPSgoz4TZ7tg3
        GlstTJPw==;
Received: from [2001:8b0:10b:5:dcc8:7ee1:2e87:984f] (helo=u3832b3a9db3152.ant.amazon.com)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qOzj5-007RaN-8h; Thu, 27 Jul 2023 12:04:15 +0000
Message-ID: <bbe3f0721e9f2965858b407afe638000f6b0d021.camel@infradead.org>
Subject: Re: [PATCH v3] KVM: x86/xen: Implement hvm_op/HVMOP_flush_tlbs
 hypercall
From:   David Woodhouse <dwmw2@infradead.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Metin Kaya <metikaya@amazon.co.uk>, kvm@vger.kernel.org,
        pbonzini@redhat.com, x86@kernel.org, bp@alien8.de, paul@xen.org,
        tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com,
        joao.m.martins@oracle.com
Date:   Thu, 27 Jul 2023 13:04:14 +0100
In-Reply-To: <ZMF8/SUw5ebkDhde@google.com>
References: <138f584bd86fe68aa05f20db3de80bae61880e11.camel@infradead.org>
         <20230418101306.98263-1-metikaya@amazon.co.uk>
         <ZHEXX/OG6suNGWPN@google.com>
         <9a58e731421edad45dff31e681b83f90c5e9775e.camel@infradead.org>
         <ZMF8/SUw5ebkDhde@google.com>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
        boundary="=-srmHNtDb1Dsw2Pgkzbrt"
User-Agent: Evolution 3.44.4-0ubuntu1 
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-srmHNtDb1Dsw2Pgkzbrt
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2023-07-26 at 13:07 -0700, Sean Christopherson wrote:
> On Tue, Jul 25, 2023, David Woodhouse wrote:
> > On Fri, 2023-05-26 at 13:32 -0700, Sean Christopherson wrote:
> > > =C2=A0 : Aha!=C2=A0 And QEMU appears to have Xen emulation support.=
=C2=A0 That means KVM-Unit-Tests
> > > =C2=A0 : is an option.=C2=A0 Specifically, extend the "access" test t=
o use this hypercall instead
> > > =C2=A0 : of INVLPG.=C2=A0 That'll verify that the flush is actually b=
eing performed as expteced.
> >=20
> > That works. Metin has a better version that actually sets up the
> > hypercall page properly and uses it, but that one bails out when Xen
> > support isn't present, and doesn't show the failure mode quite so
> > clearly. This is the simple version:
>=20
> IIUC, y'all have already written both tests, so why not post both?=C2=A0 =
I certainly
> won't object to more tests if they provide different coverage.

Yeah, it just needed cleaning up.

This is what we have; Metin will submit it for real after a little more
polishing. It modifies the existing access test so that *if* it's run
in a Xen environment, and *if* the HVMOP_flush_tlbs call returns
success instead of -ENOSYS, it'll use that instead of invlpg.

In itself, that doesn't give us an automatic regression tests, because
you still need to run it manually =E2=80=94 as before,
 qemu-system-x86_64 -device isa-debug-exit,iobase=3D0xf4,iosize=3D0x4 -vnc =
none -serial stdio -device pci-testdev --accel kvm,xen-version=3D0x4000a,ke=
rnel-irqchip=3Dsplit  -kernel ~/access_test.flat

If we really want to, we can look at making it run that way when qemu
and the host kernel support Xen guests...?

diff --git a/x86/access.c b/x86/access.c
index 83c8221..8c6e44a 100644
--- a/x86/access.c
+++ b/x86/access.c
@@ -4,6 +4,7 @@
 #include "asm/page.h"
 #include "x86/vm.h"
 #include "access.h"
+#include "alloc_page.h"
=20
 #define true 1
 #define false 0
@@ -253,12 +254,90 @@ static void clear_user_mask(pt_element_t *ptep, int l=
evel, unsigned long virt)
 	*ptep &=3D ~PT_USER_MASK;
 }
=20
+uint8_t *hypercall_page;
+
+#define __HYPERVISOR_hvm_op	34
+#define HVMOP_flush_tlbs	5
+
+static inline int do_hvm_op_flush_tlbs(void)
+{
+	long res =3D 0, _a1 =3D (long)(HVMOP_flush_tlbs), _a2 =3D (long)(NULL);
+
+	asm volatile ("call *%[offset]"
+#if defined(__x86_64__)
+		      : "=3Da" (res), "+D" (_a1), "+S" (_a2)
+#else
+		      : "=3Da" (res), "+b" (_a1), "+c" (_a2)
+#endif
+		      : [offset] "r" (hypercall_page + (__HYPERVISOR_hvm_op * 32))
+		      : "memory");
+
+	if (res)
+		printf("hvm_op/HVMOP_flush_tlbs failed: %ld.", res);
+
+	return (int)res;
+}
+
+#define XEN_CPUID_FIRST_LEAF    0x40000000
+#define XEN_CPUID_SIGNATURE_EBX 0x566e6558 /* "XenV" */
+#define XEN_CPUID_SIGNATURE_ECX 0x65584d4d /* "MMXe" */
+#define XEN_CPUID_SIGNATURE_EDX 0x4d4d566e /* "nVMM" */
+
+static void init_hypercalls(void)
+{
+	struct cpuid c;
+	u32 base;
+	bool found =3D false;
+
+	for (base =3D XEN_CPUID_FIRST_LEAF; base < XEN_CPUID_FIRST_LEAF + 0x10000=
;
+			base +=3D 0x100) {
+		c =3D cpuid(base);
+		if ((c.b =3D=3D XEN_CPUID_SIGNATURE_EBX) &&
+		    (c.c =3D=3D XEN_CPUID_SIGNATURE_ECX) &&
+		    (c.d =3D=3D XEN_CPUID_SIGNATURE_EDX) &&
+		    ((c.a - base) >=3D 2)) {
+			found =3D true;
+			break;
+		}
+	}
+	if (!found) {
+		printf("Using native invlpg instruction\n");
+		return;
+	}
+
+	hypercall_page =3D alloc_pages_flags(0, AREA_ANY | FLAG_DONTZERO);
+	if (!hypercall_page)
+		report_abort("failed to allocate hypercall page");
+
+	memset(hypercall_page, 0xc3, PAGE_SIZE);
+
+	c =3D cpuid(base + 2);
+	wrmsr(c.b, (u64)hypercall_page);
+	barrier();
+
+	if (hypercall_page[0] =3D=3D 0xc3)
+		report_abort("Hypercall page not initialised correctly\n");
+
+	/*
+	 * Fall back to invlpg instruction if HVMOP_flush_tlbs hypercall is
+	 * unsuported.
+	 */
+	if (do_hvm_op_flush_tlbs()) {
+		printf("Using native invlpg instruction\n");
+		free_page(hypercall_page);
+		hypercall_page =3D NULL;
+		return;
+	}
+
+	printf("Using Xen HVMOP_flush_tlbs hypercall\n");
+}
+
 static void set_user_mask(pt_element_t *ptep, int level, unsigned long vir=
t)
 {
 	*ptep |=3D PT_USER_MASK;
=20
 	/* Flush to avoid spurious #PF */
-	invlpg((void*)virt);
+	hypercall_page ? do_hvm_op_flush_tlbs() : invlpg((void*)virt);
 }
=20
 static unsigned set_cr4_smep(ac_test_t *at, int smep)
@@ -577,7 +656,7 @@ fault:
=20
 static void ac_set_expected_status(ac_test_t *at)
 {
-	invlpg(at->virt);
+	hypercall_page ? do_hvm_op_flush_tlbs() : invlpg((void*)at->virt);
=20
 	if (at->ptep)
 		at->expected_pte =3D *at->ptep;
@@ -1162,6 +1241,10 @@ int ac_test_run(int pt_levels)
 	printf("run\n");
 	tests =3D successes =3D 0;
=20
+	setup_vm();
+
+	init_hypercalls();
+
 	shadow_cr0 =3D read_cr0();
 	shadow_cr4 =3D read_cr4();
 	shadow_cr3 =3D read_cr3();
@@ -1234,6 +1317,9 @@ int ac_test_run(int pt_levels)
 		successes +=3D ac_test_cases[i](&pt_env);
 	}
=20
+	if (hypercall_page)
+		free_page(hypercall_page);
+
 	printf("\n%d tests, %d failures\n", tests, tests - successes);
=20
 	return successes =3D=3D tests;
--=20
2.34.1



--=-srmHNtDb1Dsw2Pgkzbrt
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCCEkQw
ggYQMIID+KADAgECAhBNlCwQ1DvglAnFgS06KwZPMA0GCSqGSIb3DQEBDAUAMIGIMQswCQYDVQQG
EwJVUzETMBEGA1UECBMKTmV3IEplcnNleTEUMBIGA1UEBxMLSmVyc2V5IENpdHkxHjAcBgNVBAoT
FVRoZSBVU0VSVFJVU1QgTmV0d29yazEuMCwGA1UEAxMlVVNFUlRydXN0IFJTQSBDZXJ0aWZpY2F0
aW9uIEF1dGhvcml0eTAeFw0xODExMDIwMDAwMDBaFw0zMDEyMzEyMzU5NTlaMIGWMQswCQYDVQQG
EwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYD
VQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNlY3RpZ28gUlNBIENsaWVudCBBdXRoZW50
aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKC
AQEAyjztlApB/975Rrno1jvm2pK/KxBOqhq8gr2+JhwpKirSzZxQgT9tlC7zl6hn1fXjSo5MqXUf
ItMltrMaXqcESJuK8dtK56NCSrq4iDKaKq9NxOXFmqXX2zN8HHGjQ2b2Xv0v1L5Nk1MQPKA19xeW
QcpGEGFUUd0kN+oHox+L9aV1rjfNiCj3bJk6kJaOPabPi2503nn/ITX5e8WfPnGw4VuZ79Khj1YB
rf24k5Ee1sLTHsLtpiK9OjG4iQRBdq6Z/TlVx/hGAez5h36bBJMxqdHLpdwIUkTqT8se3ed0PewD
ch/8kHPo5fZl5u1B0ecpq/sDN/5sCG52Ds+QU5O5EwIDAQABo4IBZDCCAWAwHwYDVR0jBBgwFoAU
U3m/WqorSs9UgOHYm8Cd8rIDZsswHQYDVR0OBBYEFAnA8vwL2pTbX/4r36iZQs/J4K0AMA4GA1Ud
DwEB/wQEAwIBhjASBgNVHRMBAf8ECDAGAQH/AgEAMB0GA1UdJQQWMBQGCCsGAQUFBwMCBggrBgEF
BQcDBDARBgNVHSAECjAIMAYGBFUdIAAwUAYDVR0fBEkwRzBFoEOgQYY/aHR0cDovL2NybC51c2Vy
dHJ1c3QuY29tL1VTRVJUcnVzdFJTQUNlcnRpZmljYXRpb25BdXRob3JpdHkuY3JsMHYGCCsGAQUF
BwEBBGowaDA/BggrBgEFBQcwAoYzaHR0cDovL2NydC51c2VydHJ1c3QuY29tL1VTRVJUcnVzdFJT
QUFkZFRydXN0Q0EuY3J0MCUGCCsGAQUFBzABhhlodHRwOi8vb2NzcC51c2VydHJ1c3QuY29tMA0G
CSqGSIb3DQEBDAUAA4ICAQBBRHUAqznCFfXejpVtMnFojADdF9d6HBA4kMjjsb0XMZHztuOCtKF+
xswhh2GqkW5JQrM8zVlU+A2VP72Ky2nlRA1GwmIPgou74TZ/XTarHG8zdMSgaDrkVYzz1g3nIVO9
IHk96VwsacIvBF8JfqIs+8aWH2PfSUrNxP6Ys7U0sZYx4rXD6+cqFq/ZW5BUfClN/rhk2ddQXyn7
kkmka2RQb9d90nmNHdgKrwfQ49mQ2hWQNDkJJIXwKjYA6VUR/fZUFeCUisdDe/0ABLTI+jheXUV1
eoYV7lNwNBKpeHdNuO6Aacb533JlfeUHxvBz9OfYWUiXu09sMAviM11Q0DuMZ5760CdO2VnpsXP4
KxaYIhvqPqUMWqRdWyn7crItNkZeroXaecG03i3mM7dkiPaCkgocBg0EBYsbZDZ8bsG3a08LwEsL
1Ygz3SBsyECa0waq4hOf/Z85F2w2ZpXfP+w8q4ifwO90SGZZV+HR/Jh6rEaVPDRF/CEGVqR1hiuQ
OZ1YL5ezMTX0ZSLwrymUE0pwi/KDaiYB15uswgeIAcA6JzPFf9pLkAFFWs1QNyN++niFhsM47qod
x/PL+5jR87myx5uYdBEQkkDc+lKB1Wct6ucXqm2EmsaQ0M95QjTmy+rDWjkDYdw3Ms6mSWE3Bn7i
5ZgtwCLXgAIe5W8mybM2JzCCBhQwggT8oAMCAQICEQDGvhmWZ0DEAx0oURL6O6l+MA0GCSqGSIb3
DQEBCwUAMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYD
VQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNlY3RpZ28g
UlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBMB4XDTIyMDEwNzAw
MDAwMFoXDTI1MDEwNjIzNTk1OVowJDEiMCAGCSqGSIb3DQEJARYTZHdtdzJAaW5mcmFkZWFkLm9y
ZzCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBALQ3GpC2bomUqk+91wLYBzDMcCj5C9m6
oZaHwvmIdXftOgTbCJXADo6G9T7BBAebw2JV38EINgKpy/ZHh7htyAkWYVoFsFPrwHounto8xTsy
SSePMiPlmIdQ10BcVSXMUJ3Juu16GlWOnAMJY2oYfEzmE7uT9YgcBqKCo65pTFmOnR/VVbjJk4K2
xE34GC2nAdUQkPFuyaFisicc6HRMOYXPuF0DuwITEKnjxgNjP+qDrh0db7PAjO1D4d5ftfrsf+kd
RR4gKVGSk8Tz2WwvtLAroJM4nXjNPIBJNT4w/FWWc/5qPHJy2U+eITZ5LLE5s45mX2oPFknWqxBo
bQZ8a9dsZ3dSPZBvE9ZrmtFLrVrN4eo1jsXgAp1+p7bkfqd3BgBEmfsYWlBXO8rVXfvPgLs32VdV
NZxb/CDWPqBsiYv0Hv3HPsz07j5b+/cVoWqyHDKzkaVbxfq/7auNVRmPB3v5SWEsH8xi4Bez2V9U
KxfYCnqsjp8RaC2/khxKt0A552Eaxnz/4ly/2C7wkwTQnBmdlFYhAflWKQ03Ufiu8t3iBE3VJbc2
5oMrglj7TRZrmKq3CkbFnX0fyulB+kHimrt6PIWn7kgyl9aelIl6vtbhMA+l0nfrsORMa4kobqQ5
C5rveVgmcIad67EDa+UqEKy/GltUwlSh6xy+TrK1tzDvAgMBAAGjggHMMIIByDAfBgNVHSMEGDAW
gBQJwPL8C9qU21/+K9+omULPyeCtADAdBgNVHQ4EFgQUzMeDMcimo0oz8o1R1Nver3ZVpSkwDgYD
VR0PAQH/BAQDAgWgMAwGA1UdEwEB/wQCMAAwHQYDVR0lBBYwFAYIKwYBBQUHAwQGCCsGAQUFBwMC
MEAGA1UdIAQ5MDcwNQYMKwYBBAGyMQECAQEBMCUwIwYIKwYBBQUHAgEWF2h0dHBzOi8vc2VjdGln
by5jb20vQ1BTMFoGA1UdHwRTMFEwT6BNoEuGSWh0dHA6Ly9jcmwuc2VjdGlnby5jb20vU2VjdGln
b1JTQUNsaWVudEF1dGhlbnRpY2F0aW9uYW5kU2VjdXJlRW1haWxDQS5jcmwwgYoGCCsGAQUFBwEB
BH4wfDBVBggrBgEFBQcwAoZJaHR0cDovL2NydC5zZWN0aWdvLmNvbS9TZWN0aWdvUlNBQ2xpZW50
QXV0aGVudGljYXRpb25hbmRTZWN1cmVFbWFpbENBLmNydDAjBggrBgEFBQcwAYYXaHR0cDovL29j
c3Auc2VjdGlnby5jb20wHgYDVR0RBBcwFYETZHdtdzJAaW5mcmFkZWFkLm9yZzANBgkqhkiG9w0B
AQsFAAOCAQEAyW6MUir5dm495teKqAQjDJwuFCi35h4xgnQvQ/fzPXmtR9t54rpmI2TfyvcKgOXp
qa7BGXNFfh1JsqexVkIqZP9uWB2J+uVMD+XZEs/KYNNX2PvIlSPrzIB4Z2wyIGQpaPLlYflrrVFK
v9CjT2zdqvy2maK7HKOQRt3BiJbVG5lRiwbbygldcALEV9ChWFfgSXvrWDZspnU3Gjw/rMHrGnql
Htlyebp3pf3fSS9kzQ1FVtVIDrL6eqhTwJxe+pXSMMqFiN0whpBtXdyDjzBtQTaZJ7zTT/vlehc/
tDuqZwGHm/YJy883Ll+GP3NvOkgaRGWEuYWJJ6hFCkXYjyR9IzCCBhQwggT8oAMCAQICEQDGvhmW
Z0DEAx0oURL6O6l+MA0GCSqGSIb3DQEBCwUAMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3Jl
YXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0
ZWQxPjA8BgNVBAMTNVNlY3RpZ28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJl
IEVtYWlsIENBMB4XDTIyMDEwNzAwMDAwMFoXDTI1MDEwNjIzNTk1OVowJDEiMCAGCSqGSIb3DQEJ
ARYTZHdtdzJAaW5mcmFkZWFkLm9yZzCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBALQ3
GpC2bomUqk+91wLYBzDMcCj5C9m6oZaHwvmIdXftOgTbCJXADo6G9T7BBAebw2JV38EINgKpy/ZH
h7htyAkWYVoFsFPrwHounto8xTsySSePMiPlmIdQ10BcVSXMUJ3Juu16GlWOnAMJY2oYfEzmE7uT
9YgcBqKCo65pTFmOnR/VVbjJk4K2xE34GC2nAdUQkPFuyaFisicc6HRMOYXPuF0DuwITEKnjxgNj
P+qDrh0db7PAjO1D4d5ftfrsf+kdRR4gKVGSk8Tz2WwvtLAroJM4nXjNPIBJNT4w/FWWc/5qPHJy
2U+eITZ5LLE5s45mX2oPFknWqxBobQZ8a9dsZ3dSPZBvE9ZrmtFLrVrN4eo1jsXgAp1+p7bkfqd3
BgBEmfsYWlBXO8rVXfvPgLs32VdVNZxb/CDWPqBsiYv0Hv3HPsz07j5b+/cVoWqyHDKzkaVbxfq/
7auNVRmPB3v5SWEsH8xi4Bez2V9UKxfYCnqsjp8RaC2/khxKt0A552Eaxnz/4ly/2C7wkwTQnBmd
lFYhAflWKQ03Ufiu8t3iBE3VJbc25oMrglj7TRZrmKq3CkbFnX0fyulB+kHimrt6PIWn7kgyl9ae
lIl6vtbhMA+l0nfrsORMa4kobqQ5C5rveVgmcIad67EDa+UqEKy/GltUwlSh6xy+TrK1tzDvAgMB
AAGjggHMMIIByDAfBgNVHSMEGDAWgBQJwPL8C9qU21/+K9+omULPyeCtADAdBgNVHQ4EFgQUzMeD
Mcimo0oz8o1R1Nver3ZVpSkwDgYDVR0PAQH/BAQDAgWgMAwGA1UdEwEB/wQCMAAwHQYDVR0lBBYw
FAYIKwYBBQUHAwQGCCsGAQUFBwMCMEAGA1UdIAQ5MDcwNQYMKwYBBAGyMQECAQEBMCUwIwYIKwYB
BQUHAgEWF2h0dHBzOi8vc2VjdGlnby5jb20vQ1BTMFoGA1UdHwRTMFEwT6BNoEuGSWh0dHA6Ly9j
cmwuc2VjdGlnby5jb20vU2VjdGlnb1JTQUNsaWVudEF1dGhlbnRpY2F0aW9uYW5kU2VjdXJlRW1h
aWxDQS5jcmwwgYoGCCsGAQUFBwEBBH4wfDBVBggrBgEFBQcwAoZJaHR0cDovL2NydC5zZWN0aWdv
LmNvbS9TZWN0aWdvUlNBQ2xpZW50QXV0aGVudGljYXRpb25hbmRTZWN1cmVFbWFpbENBLmNydDAj
BggrBgEFBQcwAYYXaHR0cDovL29jc3Auc2VjdGlnby5jb20wHgYDVR0RBBcwFYETZHdtdzJAaW5m
cmFkZWFkLm9yZzANBgkqhkiG9w0BAQsFAAOCAQEAyW6MUir5dm495teKqAQjDJwuFCi35h4xgnQv
Q/fzPXmtR9t54rpmI2TfyvcKgOXpqa7BGXNFfh1JsqexVkIqZP9uWB2J+uVMD+XZEs/KYNNX2PvI
lSPrzIB4Z2wyIGQpaPLlYflrrVFKv9CjT2zdqvy2maK7HKOQRt3BiJbVG5lRiwbbygldcALEV9Ch
WFfgSXvrWDZspnU3Gjw/rMHrGnqlHtlyebp3pf3fSS9kzQ1FVtVIDrL6eqhTwJxe+pXSMMqFiN0w
hpBtXdyDjzBtQTaZJ7zTT/vlehc/tDuqZwGHm/YJy883Ll+GP3NvOkgaRGWEuYWJJ6hFCkXYjyR9
IzGCBMcwggTDAgEBMIGsMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVz
dGVyMRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMT
NVNlY3RpZ28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEA
xr4ZlmdAxAMdKFES+jupfjANBglghkgBZQMEAgEFAKCCAeswGAYJKoZIhvcNAQkDMQsGCSqGSIb3
DQEHATAcBgkqhkiG9w0BCQUxDxcNMjMwNzI3MTIwNDE0WjAvBgkqhkiG9w0BCQQxIgQgdsiF+A5M
yaMfZKqH/WPVFkWOeZu3Whd+EBfgxKuppWwwgb0GCSsGAQQBgjcQBDGBrzCBrDCBljELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEYMBYG
A1UEChMPU2VjdGlnbyBMaW1pdGVkMT4wPAYDVQQDEzVTZWN0aWdvIFJTQSBDbGllbnQgQXV0aGVu
dGljYXRpb24gYW5kIFNlY3VyZSBFbWFpbCBDQQIRAMa+GZZnQMQDHShREvo7qX4wgb8GCyqGSIb3
DQEJEAILMYGvoIGsMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVy
MRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNl
Y3RpZ28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEAxr4Z
lmdAxAMdKFES+jupfjANBgkqhkiG9w0BAQEFAASCAgB9OzTK0Tde0+o+YbJLwbkssQOL3R97NCY9
GF6lbWGdq5rCXmLQgGAezp0n55WrWRnKviZ0la8AnmLy1S+5KFjFDgshOi+CWyFlI01Ay+GxxQ5P
tbC5qSfzOq1KB70E8J1tXNJomhL+6P0G+uLRyzz2VJLSKFPga/FKADXBEQrCWMNGoAN5K5/arZT5
hdNzCl3P66Wnd0rvJT6VvJhtWIvH/tsQ29ibAyzSJg9Adwz3mGXlEgVtgtJMLF9+LmEOdLDjhPRO
0jHortj5yuF+XWCfNOCWwzPPPN5vIwOdO/j3qjnlaXcv+jwhm4xM5U4tQUFeyuk8a1vDSxQM4hha
FxaIAIcilOBchnPL163096PWkJx6Q8eN5zoCKGcFAxIz3DzqKWyXcqUj/Ukfi87rHdFjcTXbXRco
9L6GKQLRrk1tWWCew4PTFn9I5NdSr3UaHv/xx3kpQ2gcMMszjxLL0odwEBuUVYt8lqGVCoKbLLRa
RyGny70xtcVXmGHACHgKpJZvRqVIvhvYTdF+sRnrKc/5kVS5HmlDAt2wcpj9ne/R8mT60TCCnpih
uoq1f64Z0bUKeuSUa7pHetDqwTbUY0rt1T+CeZbmNDpg94nTVZUb/cEmQpXW5LstSU4tkGfFPgNO
QvsMWbCNtzMt1hsMMNUfA2z05gDw3vbMh0rPJIzUqwAAAAAAAA==


--=-srmHNtDb1Dsw2Pgkzbrt--
