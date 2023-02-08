Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1019368EF67
	for <lists+kvm@lfdr.de>; Wed,  8 Feb 2023 13:57:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230156AbjBHM5j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Feb 2023 07:57:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230075AbjBHM5f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Feb 2023 07:57:35 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D200A5F2;
        Wed,  8 Feb 2023 04:57:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
        In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Ffucp8/xEAmC8kckx3V0pdm6JDPldUfAyruxM2zS5H4=; b=tkizqBBg53KL78CIkZuDOoC2QF
        pVOvk+Y7Uy4iQbt0RLXBzkBvfud0H20w6AyOfERyB6xrlKf/GMY5pJ+bbH0DnpN9ffTLMvR5NEhZR
        Wm2P9tb9H8zmQ/Z1Jt1NWnDgE+ADJ1yG/cZZQjJNzJkOyt60M6p/Z+zqRPS7XEICNEETmQNPtw/j7
        j/Q0p8xrWgskuuadMvBwVG/AnFCmRPUVw96oBRUyBASB7+FkbP8yiS5i9piPZjOfi35QgJD2YPBJJ
        G998KLSodY3VkWDhOr77+jnm3LSLw0H4URgQpXHvTLRKx08hy1yUVKrnryurot/1a/zl0BsFmAQ0L
        xtyZVR9Q==;
Received: from [2001:8b0:10b:5::bb3] (helo=u3832b3a9db3152.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pPk0S-001Dao-LV; Wed, 08 Feb 2023 12:57:01 +0000
Message-ID: <1b3f0855d7d3aa0de723b53a9b4787bd29c98d92.camel@infradead.org>
Subject: Re: [PATCH v7 6/9] x86/smpboot: Support parallel startup of
 secondary CPUs
From:   David Woodhouse <dwmw2@infradead.org>
To:     Brian Gerst <brgerst@gmail.com>,
        Usama Arif <usama.arif@bytedance.com>
Cc:     tglx@linutronix.de, kim.phillips@amd.com, arjan@linux.intel.com,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, x86@kernel.org, pbonzini@redhat.com,
        paulmck@kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, rcu@vger.kernel.org, mimoja@mimoja.de,
        hewenliang4@huawei.com, thomas.lendacky@amd.com, seanjc@google.com,
        pmenzel@molgen.mpg.de, fam.zheng@bytedance.com,
        punit.agrawal@bytedance.com, simon.evans@bytedance.com,
        liangma@liangbit.com
Date:   Wed, 08 Feb 2023 12:56:59 +0000
In-Reply-To: <CAMzpN2iejCnBeBdC6+92fUL2k8ZdAq_jEgXX+RSoGMhRZ0UBSA@mail.gmail.com>
References: <20230207230436.2690891-1-usama.arif@bytedance.com>
         <20230207230436.2690891-7-usama.arif@bytedance.com>
         <CAMzpN2iejCnBeBdC6+92fUL2k8ZdAq_jEgXX+RSoGMhRZ0UBSA@mail.gmail.com>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
        boundary="=-V6R4bY/l8SCKfL0iHh2X"
User-Agent: Evolution 3.44.4-0ubuntu1 
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-V6R4bY/l8SCKfL0iHh2X
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2023-02-08 at 00:09 -0500, Brian Gerst wrote:
> On Tue, Feb 7, 2023 at 6:10 PM Usama Arif <usama.arif@bytedance.com> wrot=
e:
> >=20
> > From: Thomas Gleixner <tglx@linutronix.de>
> >=20
> > Rework the real-mode startup code to allow for APs to be brought up in
> > parallel. This is in two parts:
> >=20
> > 1. Introduce a bit-spinlock to prevent them from all using the real
> > =C2=A0=C2=A0 mode stack at the same time.
> >=20
> > 2. Avoid the use of global variables for passing per-CPU information to
> > =C2=A0=C2=A0 the APs.
> >=20
> > To achieve the latter, export the cpuid_to_apicid[] array so that each
> > AP can find its own per_cpu data (and thus initial_gs, initial_stack an=
d
> > early_gdt_descr) by searching therein based on its APIC ID.
> >=20
> > Introduce a global variable 'smpboot_control' indicating to the AP how
> > it should find its APIC ID. For a serialized bringup, the APIC ID is
> > explicitly passed in the low bits of smpboot_control, while for paralle=
l
> > mode there are flags directing the AP to find its APIC ID in CPUID leaf
> > 0x0b (for X2APIC mode) or CPUID leaf 0x01 where 8 bits are sufficient.
>=20
> For the serialized bringup case, it would be simpler to just put the
> cpu number in the lower bits instead of the APIC id, skipping the
> lookup.
>=20

I seem to recall that was one of my first thoughts on seeing this
patch.

I quite liked the fact that the code path in head_64.S remained
basically the same for all cases, and was actually testing the lookup
via cpuid_to_apicid[] even when parallel boot isn't available.

But then again, we've tested that part fairly well now, so perhaps
you're right and we could do something like the below? It doesn't
actually add much more complexity; just define the entry conditions to
.Linit_cpu_data a bit more clearly and remember how to use scaled index
addressing so we don't have to explicitly multiply by 8.

I don't know that I care very much either way. It's Thomas's patch
originally, so I'll let him see if he can muster up an opinion.

diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 656e6018b9d4..d878869472a2 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -252,20 +252,23 @@ SYM_INNER_LABEL(secondary_startup_64_no_verify, SYM_L=
_GLOBAL)
 	jz	.Lsetup_cpu
=20
 	/*
-	 * Secondary CPUs find out the offsets via the APIC ID. For parallel
-	 * boot the APIC ID is retrieved from CPUID, otherwise it's encoded
-	 * in smpboot_control:
+	 * Secondary CPUs find out the offsets via their per_cpu data. For
+	 * parallel bringup they find it via the cpuid_to_apicid[] array
+	 * with their APIC ID obtained from CPUID. Otherwise the CPU number
+	 * is encoded directly in smpboot_control:
+	 *
 	 * Bit 31	STARTUP_SECONDARY flag (checked above)
 	 * Bit 30	STARTUP_APICID_CPUID_0B flag (use CPUID 0x0b)
 	 * Bit 29	STARTUP_APICID_CPUID_01 flag (use CPUID 0x01)
-	 * Bit 0-24	APIC ID if STARTUP_APICID_CPUID_xx flags are not set
+	 * Bit 0-24	CPU# if STARTUP_APICID_CPUID_xx flags are not set
 	 */
 	testl	$STARTUP_APICID_CPUID_0B, %edx
 	jnz	.Luse_cpuid_0b
 	testl	$STARTUP_APICID_CPUID_01, %edx
 	jnz	.Luse_cpuid_01
 	andl	$0x0FFFFFFF, %edx
-	jmp	.Lsetup_AP
+	mov	%edx, %ecx
+	jmp	.Linit_cpu_data
=20
 .Luse_cpuid_01:
 	mov	$0x01, %eax
@@ -288,14 +291,14 @@ SYM_INNER_LABEL(secondary_startup_64_no_verify, SYM_L=
_GLOBAL)
 	cmpl	(%rbx), %edx
 	jz	.Linit_cpu_data
 	addq	$4, %rbx
-	addq	$8, %rcx
+	inc	%rcx
 	jmp	.Lfind_cpunr
=20
 .Linit_cpu_data:
+	/* ECX contains the CPU# of the current CPU */
 	/* Get the per cpu offset */
 	leaq	__per_cpu_offset(%rip), %rbx
-	addq	%rcx, %rbx
-	movq	(%rbx), %rbx
+	movq	(%rbx,%rcx,8), %rbx
 	/* Save it for GS BASE setup */
 	movq	%rbx, initial_gs(%rip)
=20
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index cae916040c55..5149676881e0 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1146,7 +1146,7 @@ static int do_boot_cpu(int apicid, int cpu, struct ta=
sk_struct *idle,
 		early_gdt_descr.address =3D (unsigned long)get_cpu_gdt_rw(cpu);
 		initial_stack  =3D idle->thread.sp;
 	} else if (!do_parallel_bringup) {
-		smpboot_control =3D STARTUP_SECONDARY | apicid;
+		smpboot_control =3D STARTUP_SECONDARY | cpu;
 	}
=20
 	/* Enable the espfix hack for this CPU */


--=-V6R4bY/l8SCKfL0iHh2X
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
DQEHATAcBgkqhkiG9w0BCQUxDxcNMjMwMjA4MTI1NjU5WjAvBgkqhkiG9w0BCQQxIgQgEQERwWAS
gzXEtyKkYy6y+p5KoktOpIaI/rpd09Xs+Ocwgb0GCSsGAQQBgjcQBDGBrzCBrDCBljELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEYMBYG
A1UEChMPU2VjdGlnbyBMaW1pdGVkMT4wPAYDVQQDEzVTZWN0aWdvIFJTQSBDbGllbnQgQXV0aGVu
dGljYXRpb24gYW5kIFNlY3VyZSBFbWFpbCBDQQIRAMa+GZZnQMQDHShREvo7qX4wgb8GCyqGSIb3
DQEJEAILMYGvoIGsMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVy
MRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNl
Y3RpZ28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEAxr4Z
lmdAxAMdKFES+jupfjANBgkqhkiG9w0BAQEFAASCAgCrHOInREQVFuEo3oBzGJm7ylHUKK9vqtKz
g5nwTIxY6b5DijbSnPm/nzA/Vr/wHQCK0erSKpfCUAmKyPvzq7EUv7tOo+fHDjlLN8E892BItB6k
2tQCTqlMD2rwOcGPT2EVkYm4qJB8KYoUeAPMieMpFYJOx6f+hl0VCmBy17DY+0WJi7XuYkT8kAQr
zOthdbyP6PgquYdfxCQJ6EPIi+pZW8zPjqBFnynXbWI8VYwXG8iBXo2AKobtwIABsMjVSI5eFHZP
u1JUxk7Ek/YOHE3xjG2TzC170zjQkrc7yhBJs44a67glVC5tTvSn9zKEoGS5Dye9nQIGQ6rjC0Rw
OizQ1xO0lwFIrbBp8lN+fdiFszj3e1grM8uHTqGZCRptpPrHfdRchmlf7sA3JI9iGRYDkrj/Y5SS
sfKmjDCcJ9Akon99Snnt/DLxQA94jbMh74k1AibuYcBY5LYqoq9KAd/avEmSF63jF1Yvm92tBEnD
AdR3Tp4oEotSbrfX+xWJO/Ad4ko9uNdGS2ldvcac1T9+98h+yAPnopO/aVAK2E15uAy+P1wTgdch
IMPQQZvCfxEKS9hPPUlkyUGDbU33EIZUsXmnJk/2TEE91GPoarTkLxzL/34u40B+64AzihJjqThG
Fz6T7PuOD0YsV80XLG75LgxQ25cvu/Fx6YTyIkEaNgAAAAAAAA==


--=-V6R4bY/l8SCKfL0iHh2X--
