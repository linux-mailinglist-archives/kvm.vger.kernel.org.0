Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BAB67CAF93
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 18:35:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234237AbjJPQfZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 12:35:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234083AbjJPQeQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 12:34:16 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6588883F1;
        Mon, 16 Oct 2023 09:25:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
        In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=3h9ZG7EQdaNIpXvscHdQVx1aAF1LiBEOE4+vvMmYMi4=; b=vOYhrLeCEAOOBmxDZZRJsIYfxr
        QaW7Pd9wuQdhh7qXX7lLzUo9MesWJ9tLxfP9Xi6HpPUAaQF3yL5TJhQ8tqr0b93uC+3maIqw3lAce
        kwkh6XXLiR+tXoakeS8a5+Ut2gb80NI+pBsqV35KzXF63XZkOuDABQ+44zm+tLoUKoDoMxscUvT4I
        AwUsIAMHh0nZfwosk4cKHq/ccYNgonkrJFi2ODid7kSdnneKNihgDR/RdifHgXLZijWpWbQcLzqDb
        fzkH5CfPE/Lov+C+SfSY0FE74nkjeBiBKeLQkDNl8A71U8TFhnRP3CERQYK/0qhi+F57x1dLHSEuW
        5+7P4fLg==;
Received: from [2001:8b0:10b:5:3e6:2df8:f867:bc00] (helo=u3832b3a9db3152.ant.amazon.com)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qsQOs-0074pb-8I; Mon, 16 Oct 2023 16:25:02 +0000
Message-ID: <03afed7eb3c1e5f4b2b8ecfd8616ae5c6f1819e9.camel@infradead.org>
Subject: Re: [PATCH RFC 1/1] KVM: x86: add param to update master clock
 periodically
From:   David Woodhouse <dwmw2@infradead.org>
To:     Dongli Zhang <dongli.zhang@oracle.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Joe Jin <joe.jin@oracle.com>, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com
Date:   Mon, 16 Oct 2023 17:25:01 +0100
In-Reply-To: <993cc7f9-a134-8086-3410-b915fe5db7a5@oracle.com>
References: <ZRtl94_rIif3GRpu@google.com>
         <9975969725a64c2ba2b398244dba3437bff5154e.camel@infradead.org>
         <ZRysGAgk6W1bpXdl@google.com>
         <d6dc1242ff731cf0f2826760816081674ade9ff9.camel@infradead.org>
         <ZR2pwdZtO3WLCwjj@google.com>
         <34057852-f6c0-d6d5-261f-bbb5fa056425@oracle.com>
         <ZSXqZOgLYkwLRWLO@google.com>
         <8f3493ca4c0e726d5c3876bb7dd2cfc432d9deaa.camel@infradead.org>
         <ZSmHcECyt5PdZyIZ@google.com>
         <cf2b22fc-78f5-dfb9-f0e6-5c4059a970a2@oracle.com>
         <ZSnSNVankCAlHIhI@google.com>
         <BD4C4E71-C743-4B79-93CA-0F3AC5423412@infradead.org>
         <993cc7f9-a134-8086-3410-b915fe5db7a5@oracle.com>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
        boundary="=-KfaHPII2pNzSsNHxedNY"
User-Agent: Evolution 3.44.4-0ubuntu2 
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-KfaHPII2pNzSsNHxedNY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2023-10-16 at 08:47 -0700, Dongli Zhang wrote:
> Hi David and Sean,
>=20
> On 10/14/23 02:49, David Woodhouse wrote:
> >=20
> >=20
> > On 14 October 2023 00:26:45 BST, Sean Christopherson <seanjc@google.com=
> wrote:
> > > > 2. Suppose the KVM host has been running for long time, and the dri=
ft between
> > > > two domains would be accumulated to super large? (Even it may not i=
ntroduce
> > > > anything bad immediately)
> > >=20
> > > That already happens today, e.g. unless the host does vCPU hotplug or=
 is using
> > > XEN's shared info page, masterclock updates effectively never happen.=
=C2=A0 And I'm
> > > not aware of a single bug report of someone complaining that kvmclock=
 has drifted
> > > from the host clock.=C2=A0 The only bug reports we have are when KVM =
triggers an update
> > > and causes time to jump from the guest's perspective.
> >=20
> > I've got reports about the Xen clock going backwards, and also
> > about it drifting over time w.r.t. the guest's TSC clocksource so
> > the watchdog in the guest declares its TSC clocksource unstable.=20
>=20
> I assume you meant Xen on KVM (not Xen guest on Xen hypervisor). Accordin=
g to my
> brief review of xen hypervisor code, it looks using the same algorithm to
> calculate the clock at hypervisor side, as in the xen guest.

Right. It's *exactly* the same thing. Even the same pvclock ABI in the
way it's exposed to the guest (in the KVM case via the MSR, in the Xen
case it's in the vcpu_info or a separate vcpu_time_info set up by Xen
hypercalls).

> Fortunately, the "tsc=3Dreliable" my disable the watchdog, but I have no =
idea if
> it impacts Xen on KVM.

Right. I think Linux as a KVM guest automatically disables the
watchdog, or at least refuses to use the KVM clock as the watchdog for
the TSC clocksource?

Xen guests, on the other hand, aren't used to the Xen clock being as
unreliable as the KVM clock is, so they *do* use it as a watchdog for
the TSC clocksource.

> > I don't understand *why* we update the master lock when we populate
> > the Xen shared info. Or add a vCPU, for that matter.

Still don't...

> > > > The idea is to never update master clock, if tsc is stable (and mas=
terclock is
> > > > already used).
> > >=20
> > > That's another option, but if there are no masterclock updates, then =
it suffers
> > > the exact same (theoretical) problem as #2.=C2=A0 And there are real =
downsides, e.g.
> > > defining when KVM would synchronize kvmclock with the host clock woul=
d be
> > > significantly harder...
> >=20
> > I thought the definition of such an approach would be that we
> > *never* resync the kvmclock to anything. It's based purely on the
> > TSC value when the guest started, and the TSC frequency. The
> > pvclock we advertise to all vCPUs would be the same, and would
> > *never* change except on migration.
> >=20
> > (I guess that for consistency we would scale first to the *guest*
> > TSC and from that to nanoseconds.)
> >=20
> > If userspace does anything which makes that become invalid,
> > userspace gets to keep both pieces. That includes userspace having
> > to deal with host suspend like migration, etc.
>=20
> Suppose we are discussing a non-permanenet solution, I would suggest:
>=20
> 1. Document something to accept that kvm-clock (or pvclock on KVM, includ=
ing Xen
> on KVM) is not good enough in some cases, e.g., vCPU hotplug.

I still don't understand the vCPU hotplug case.

In the case where the TSC is actually sane, why would we need to reset
the masterclock on vCPU hotplug?=20

The new vCPU gets its TSC synchronised to the others, and its kvmclock
parameters (mul/shift/offset based on the guest TSC) can be *precisely*
the same as the other vCPUs too, can't they? Why reset anything?

> 2. Do not reply on any userspace change, so that the solution can be easi=
er to
> apply to existing environments running old KVM versions.
>=20
> That is, to limit the change within KVM.
>=20
> 3. The options would be to (1) stop updating masterclock in the ideal sce=
nario
> (e.g., stable tsc), or to (2) refresh periodically to minimize the drift.

If the host TSC is sane, just *never* update the KVM masterclock. It
"drifts" w.r.t. the host CLOCK_MONOTONIC_RAW and nobody will ever care.

The only opt-in we need from userspace for that is to promise that the
host TSC will never get mangled, isn't it?

(We probably want to be able to export the pvclock information to
userspace (in terms of the mul/shift/offset from host TSC to guest TSC
and then the mul/shift/offset to kvmclock). Userspace may want to make
things like the PIT/HPET/PMtimer run on that clock.)


--=-KfaHPII2pNzSsNHxedNY
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
DQEHATAcBgkqhkiG9w0BCQUxDxcNMjMxMDE2MTYyNTAxWjAvBgkqhkiG9w0BCQQxIgQgNOdADH8r
M/KfhpmV9rAPiIVzlDH89+JIXihCDANUtaowgb0GCSsGAQQBgjcQBDGBrzCBrDCBljELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEYMBYG
A1UEChMPU2VjdGlnbyBMaW1pdGVkMT4wPAYDVQQDEzVTZWN0aWdvIFJTQSBDbGllbnQgQXV0aGVu
dGljYXRpb24gYW5kIFNlY3VyZSBFbWFpbCBDQQIRAMa+GZZnQMQDHShREvo7qX4wgb8GCyqGSIb3
DQEJEAILMYGvoIGsMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVy
MRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNl
Y3RpZ28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEAxr4Z
lmdAxAMdKFES+jupfjANBgkqhkiG9w0BAQEFAASCAgCyN/gxM/sYz9JNIA/Un2qjlne/FgDyGcnE
3XCDHdrmYxw73aLirBWtGT8qYNevu/zF6TTW1R44CbQM7N8F24tXO8NLgSPxJVpgdKmjxYz2vyjW
65Qsb3zQhKXg/9KRGxC5Z1dSFKj4Hj1aI2kchrf/frIt0uHEyO84lj81hZY2Pb83haASUaYC+XbP
8RsGLzlvK5FzvycqCfbOMBkBEkwNEC5sUqKO9C9PVmc8yVhzyxDOhJT9tHT6COVbAnymsKLlz+ui
J4s7MpeiWETIDyX8VOo9Qr85rQu7gCCPDYwO6ZiEtSJ864vvvaTFomwHRqoY3nseawfP+fVGFopB
hB6/pF3jKsNJZ/RjVVVnL25oWE6M/F+0piXgtX9z2ujnWoiB6nXRxhXX3OedpqjWw2yl7MEU5Oqg
XURvUzRTfNb6jYqMES6x+g5ywBPpPFV9GHTPgEERmk/0jKz5MjF8kRuopPMu1853Gih6sAb1477f
fkT6YjABiqUA9zhA2bqgPm2rcHJPRPg7ilmcdwtD9XolQOAqPH9+ou+4UaS6YwI2d9ZatdTpDedb
5oVv96oUGOmJ8zVCSqoV8198OGN40BzY5gBNR3gQPKj+n7cLKdvh33bIeu7exHYIvlxILjjHkb4P
6YwPKwOdb9B5k8FJljdVq9tJ08lrzRQlkT7e3nExOQAAAAAAAA==


--=-KfaHPII2pNzSsNHxedNY--
