Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A2306E688D
	for <lists+kvm@lfdr.de>; Tue, 18 Apr 2023 17:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230120AbjDRPry (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Apr 2023 11:47:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230064AbjDRPrw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Apr 2023 11:47:52 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27EA97A94
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 08:47:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
        In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=6ECCm2uwhc505xDfzOlTNFpHnyZbVbz+ceT+2WGv5Lg=; b=YVfz1fbRvselV2q/lJ0doY/cjB
        3991hziMKp6ZGgwwx6MWZ9z1vdosuvltPJIfLZT/7In6MpoL0q7DnVJA+ggV88mV8pqffOxOpSO96
        EpRPG/CaJ8A8FRprpIm91/GD9kVovs+5ieACYq0kjoV9PtKQC5AOFLtlk1NLJPC1G7FE8LBDFZTXx
        RKpJDJzUxbjiDr6CnNQQWSlhF2lsNTDknhH+Q6ffiYCS7dRYAETCnqnnoy88Ord3Perp8DzDjZsa5
        8BxDStGtQUXIk7MsJngmB5NesjEyYF5wmNT8u+YT8JeKeegf6XQMt/hh3y/hFoU5eIdhUHA4bWBe1
        3pXqnwiQ==;
Received: from [2001:8b0:10b:5:2a80:a926:b942:11ba] (helo=u3832b3a9db3152.ant.amazon.com)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ponYX-00CQE6-R1; Tue, 18 Apr 2023 15:47:46 +0000
Message-ID: <22a8fffbcb281e31ff16973d5107398f993ab542.camel@infradead.org>
Subject: Re: [EXTERNAL][PATCH v2] KVM: x86/xen: Implement
 hvm_op/HVMOP_flush_tlbs hypercall
From:   David Woodhouse <dwmw2@infradead.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Metin Kaya <metikaya@amazon.co.uk>, kvm@vger.kernel.org,
        pbonzini@redhat.com, x86@kernel.org, bp@alien8.de, paul@xen.org,
        tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com,
        joao.m.martins@oracle.com
Date:   Tue, 18 Apr 2023 16:47:44 +0100
In-Reply-To: <ZD6s4w2NDtoYZSuH@google.com>
References: <20230417122206.34647-1-metikaya@amazon.co.uk>
         <20230417122206.34647-2-metikaya@amazon.co.uk>
         <ZD10aFK0heJrs6f2@google.com>
         <138f584bd86fe68aa05f20db3de80bae61880e11.camel@infradead.org>
         <ZD6s4w2NDtoYZSuH@google.com>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
        boundary="=-Sk2Sa5IJvZhZlJV1T4uL"
User-Agent: Evolution 3.44.4-0ubuntu1 
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-Sk2Sa5IJvZhZlJV1T4uL
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2023-04-18 at 07:44 -0700, Sean Christopherson wrote:
> On Tue, Apr 18, 2023, David Woodhouse wrote:
> > On Mon, 2023-04-17 at 09:31 -0700, Sean Christopherson wrote:
> > > On Mon, Apr 17, 2023, Metin Kaya wrote:
> > > > HVMOP_flush_tlbs suboperation of hvm_op hypercall allows a guest to
> > > > flush all vCPU TLBs. There is no way for the VMM to flush TLBs from
> > > > userspace.
> > >=20
> > > Ah, took me a minute to connect the dots.=C3=AF=C2=BF=C2=BD Monday mo=
rning is definitely partly
> > > to blame, but it would be helpful to expand this sentence to be more =
explicit as
> > > to why userspace's inability to efficiently flush TLBs.
> > >=20
> > > And strictly speaking, userspace _can_ flush TLBs, just not in a prec=
ise, efficient
> > > way.
> >=20
> > Hm, how? We should probably implement that in userspace as a fallback,
> > however much it sucks.
>=20
> Oh, the suckage is high :-)=C2=A0 Use KVM_{G,S}ET_SREGS2 to toggle any CR=
{0,3,4}/EFER
> bit and __set_sregs() will reset the MMU context.

Oh, that suckage is quite high indeed. I'm not actually sure I'll
bother doing this in QEMU. It's quite esoteric; Linux has never used it
and I think that after launching <mumble> million production Xen guests
this way we've only ever seen it used by some FreeBSD variant.

It doesn't seem to be in mainline FreeBSD; there's a hint of it here
https://people.freebsd.org/~dfr/freebsd-6.x-xen-31032009.diff for
example but it's disabled even then:

 	if (pmap =3D=3D kernel_pmap || pmap->pm_active =3D=3D all_cpus) {
-		invltlb();
-		smp_invltlb();
+#if defined(XENHVM) && defined(notdef)
+		/*
+		 * As far as I can tell, this makes things slower, at
+		 * least where there are only two physical cpus and
+		 * the host is not overcommitted.
+		 */
+		if (is_running_on_xen()) {
+			HYPERVISOR_hvm_op(HVMOP_flush_tlbs, NULL);
+		} else
+#endif
+		{
+			invltlb();
+			smp_invltlb();
+		}

>  Note that without this fix[*]
> that I'm going to squeeze into 6.4, the MMU context reset may result in a=
ll TDP
> MMU roots being freed and reallocated.
>=20
> [*] https://lore.kernel.org/all/20230413231251.1481410-1-seanjc@google.co=
m
>=20
> >=20
> > > > =C3=AF=C2=BF=C2=BDarch/x86/kvm/xen.c=C3=AF=C2=BF=C2=BD=C3=AF=C2=BF=
=C2=BD=C3=AF=C2=BF=C2=BD=C3=AF=C2=BF=C2=BD=C3=AF=C2=BF=C2=BD=C3=AF=C2=BF=C2=
=BD=C3=AF=C2=BF=C2=BD=C3=AF=C2=BF=C2=BD=C3=AF=C2=BF=C2=BD=C3=AF=C2=BF=C2=BD=
=C3=AF=C2=BF=C2=BD=C3=AF=C2=BF=C2=BD=C3=AF=C2=BF=C2=BD=C3=AF=C2=BF=C2=BD=C3=
=AF=C2=BF=C2=BD=C3=AF=C2=BF=C2=BD | 31 ++++++++++++++++++++++++++++++
> > > > =C3=AF=C2=BF=C2=BDinclude/xen/interface/hvm/hvm_op.h |=C3=AF=C2=BF=
=C2=BD 3 +++
> > >=20
> > > Modifications to uapi headers is conspicuously missing.=C3=AF=C2=BF=
=C2=BD I.e. there likely needs
> > > to be a capability so that userspace can query support.
> >=20
> > Nah, nobody cares. If the kernel "accelerates" this hypercall, so be
> > it. Userspace will just never get the KVM_EXIT_XEN for that hypercall
> > because it'll be magically handled, like the others.
>=20
> Ah, that makes sense, I was thinking userspace would complain if it got t=
he
> "unexpected" exit.

I've tried to follow a model where userspace is *always* expected to
implement the hypercall, and if the kernel chooses to intervene to
accelerate it, that's a bonus.

It saves a bunch of complexity in error handling in the kernel when we
can just say "screw this, let userspace cope".

--=-Sk2Sa5IJvZhZlJV1T4uL
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
DQEHATAcBgkqhkiG9w0BCQUxDxcNMjMwNDE4MTU0NzQ0WjAvBgkqhkiG9w0BCQQxIgQgft/I/oSY
qkZiXXvboeZKJ1y1NqfPgOI8JX3CRctz/kwwgb0GCSsGAQQBgjcQBDGBrzCBrDCBljELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEYMBYG
A1UEChMPU2VjdGlnbyBMaW1pdGVkMT4wPAYDVQQDEzVTZWN0aWdvIFJTQSBDbGllbnQgQXV0aGVu
dGljYXRpb24gYW5kIFNlY3VyZSBFbWFpbCBDQQIRAMa+GZZnQMQDHShREvo7qX4wgb8GCyqGSIb3
DQEJEAILMYGvoIGsMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVy
MRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNl
Y3RpZ28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEAxr4Z
lmdAxAMdKFES+jupfjANBgkqhkiG9w0BAQEFAASCAgA4im5G2P8K7Y2Jm/Mezvt6s/xNVvVTPqfq
7eWMgunFwyK16gDzQOtdcEw3Iipdc8LnfjNCE+N+ju4YTb1HD99GrfTiqikQHwpIhgyYGJEaWfkN
sEWPnm46FkX8IWzgYt4ixIP2xWm3S0vN3fN/X3DIduv/FPPPVv5n60AKrrqUYi1NHiXygIwTq1wH
hAlxEzcBymOaxgnjVsDLyJ5+PcubVBFdKQItoeOphM9kd236dsKrvFBEtVgo1K+4J0IbcsWREksT
sDdiOvC5VxoX9da3XFlrYYeSk0Oyikov5C9ZfVF1QN0Hoc0pMdte2ogwQbBBje0WUEdVy2OX5i9x
zsJnZyPWY3LfZGSiHlLwKpQ0hoUbCXhmwKZNAzXMDRSKDZ5qVJbVQdrJjEPDUZrQZPvpIQPkFWxi
Fu65qu7vZPOUAmzXIEpsMNOeCqC/DxNT+wKfAslgbqrtKoWGTB8y+iZ7garFTUaegNLf+v2nPiYW
J1rA7ohqpRWztKWJDgvsyNn3jPq11nRjyBmEv+6BxVEV8HiALGtACmlO/BJgH/8+6hLJM2dC7BeM
rhug6R1T5qSKjpT+k0kbHUF0+sdeO1RRaaEQkuQIr8ToiRZ7htnfWfn+e4WkQxgdKt4Y0lbgzzZX
dDONcEFmsTtVoT8VkBzI+X/00jGJtJdJCqvyUHf+OAAAAAAAAA==


--=-Sk2Sa5IJvZhZlJV1T4uL--
