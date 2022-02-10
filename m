Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38FD24B119D
	for <lists+kvm@lfdr.de>; Thu, 10 Feb 2022 16:23:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243604AbiBJPXd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Feb 2022 10:23:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243609AbiBJPX2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Feb 2022 10:23:28 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96792F06;
        Thu, 10 Feb 2022 07:23:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=MIME-Version:Content-Type:References:
        In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=FYBFXCIpPLigdeimXBBEeOso2XSdDYroHfEwXqWyd48=; b=4YbuZB3YAQIReNTI3maxsYAtWA
        HE/feeX4YAdV+Z9cTu2fioU4G8P7jKL4/XSmFKAszBvLK/yqIVb7DQXOuk1Wf2GSiN2YC3+4ssnpC
        B4l/HSr9C9stjS2xMK8rFS3Da+9c4Zy1NXCZQ107m3h8gBQ22qponnzFra4z8a9NMY1nO8o4fv7dI
        syCrM6dnBws5tOo1fcyiw3YLZ2c8niR+xjVkLGDfh1Jr2qpiEidZu15GatobUIJniOG7Nz9b/jghA
        o/PmwkPxvsye9Z7JiTvswrAMRmFVHkX8wzzIReb5Rlk7zdYc2HyLZFtW+qIYl93yEC5kzv/DMiCP1
        H62Rifrg==;
Received: from [2001:8b0:10b:1::3ae] (helo=u3832b3a9db3152.ant.amazon.com)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nIBHu-004DQW-Sc; Thu, 10 Feb 2022 15:23:15 +0000
Message-ID: <776740ea7c05a6c17fa05a809b4cbeb824b5afa2.camel@infradead.org>
Subject: Re: [EXTERNAL] [PATCH RFC 12/39] KVM: x86/xen: store virq when
 assigning evtchn
From:   David Woodhouse <dwmw2@infradead.org>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
        "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "ankur.a.arora@oracle.com" <ankur.a.arora@oracle.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date:   Thu, 10 Feb 2022 15:23:10 +0000
In-Reply-To: <97bdf580-c1ff-0f2e-989c-da73a2115e7b@oracle.com>
References: <20190220201609.28290-1-joao.m.martins@oracle.com>
         <20190220201609.28290-13-joao.m.martins@oracle.com>
         <b750291466f3c89e0a393e48079c087704b217a5.camel@amazon.co.uk>
         <97bdf580-c1ff-0f2e-989c-da73a2115e7b@oracle.com>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
        boundary="=-AnJglfCL3qBfRD4dOpmc"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-AnJglfCL3qBfRD4dOpmc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2022-02-10 at 12:17 +0000, Joao Martins wrote:
> On 2/8/22 16:17, Woodhouse, David wrote:
> > And then we have the *outbound* events, which the guest can invoke with
> > the EVTCHNOP_send hypercall. Those are either:
> >  =E2=80=A2 IPI, raising the same port# on the guest
> >  =E2=80=A2 Interdomain looped back to a different port# on the guest
> >  =E2=80=A2 Interdomain triggering an eventfd.
> >=20
>=20
> /me nods
>=20
> I am forgetting why you one do this on Xen:
>=20
> * Interdomain looped back to a different port# on the guest

It's one of the few things we had to fix up when we started running PV
guests in the 'shim' under KVM. I don't know that it actually sends
loopback events via the true Xen (or KVM) host, but it does at least
register them so that the port# is 'reserved' and the host won't
allocate that port for anything else. It does it at least for the
console port.

For the inbound vs. outbound thing.... I did ponder a really simple API
design in which outbound ports are *only* ever associated with an
eventfd, and for IPIs the VMM would be expected to bind those as IRQFD
to an inbound event on the same port#.

You pointed out that it was quite inefficient, but... we already have
complex hacks to bypass the eventfd for posted interrupts when the
source and destination "match", and perhaps we could do something
similar to allow EVTCHNOP_send to deliver directly to a local port#
without having to go through all the eventfd code?

But the implementation of that would end up being awful, *and* the
userspace API isn't even that nice despite being "simple", because it
would force userspace to allocate a whole bunch of eventfds and use
space in the IRQ routing table for them. So it didn't seem worth it.
Let's just let userspace tell us explicitly the vcpu/port/prio instead
of having to jump through hoops to magically work it out from matching
eventfds.

> > In the last case, that eventfd can be set up with IRQFD for direct
> > event channel delivery to a different KVM/Xen guest.
> >=20
> > I've used your implemention, with an idr for the outbound port# space
> > intercepting EVTCHNOP_send for known ports and only letting userspace
> > see the hypercall if it's for a port# the kernel doesn't know. Looks a
> > bit like
> > https://git.infradead.org/users/dwmw2/linux.git/commitdiff/b4fbc49218a
> >=20
> >=20
> >=20
> > But I *don't* want to do the VIRQ part shown above, "spotting" the VIRQ
> > in that outbound port# space and squirreling the information away into
> > the kvm_vcpu for when we need to deliver a timer event.
> >=20
> > The VIRQ isn't part of the *outbound* port# space; it isn't a port to
> > which a Xen guest can use EVTCHNOP_send to send an event.
>=20
> But it is still an event channel which port is unique regardless of port
> type/space hence (...)
>=20
> > If anything,
> > it would be part of the *inbound* port# space, in the KVM IRQ routing
> > table. So perhaps we could have a similar snippet in
> > kvm_xen_setup_evtchn() which spots a VIRQ and says "aha, now I know
> > where to deliver timer events for this vCPU".
> >=20
>=20
> (...) The thinking at the time was mainly simplicity so our way of saying
> 'offload the evtchn to KVM' was through the machinery that offloads the o=
utbound
> part (using your terminology). I don't think even using XEN_EVENTFD as pr=
oposed
> here that that one could send an VIRQ via EVTCHNOP_send (I could be wrong=
 as
> it has been a long time).

I confess I didn't test it but it *looked* like you could, while true
Xen wouldn't permit that.

> Regardless, I think you have a good point to split the semantics and (...=
)

> >=20
> > So I think I'm going to make the timer VIRQ (port#, priority) into an
> > explicit KVM_XEN_VCPU_ATTR_TYPE.
>=20
> (...) thus this makes sense. Do you particularly care about
> VIRQ_DEBUG?


Not really. Especially not as something to accelerate in KVM.

Our environment doesn't have any way to deliver that to guests,
although we *do* have an API call to deliver "diagnostic interrupt"
which maps to an NMI, and we *have* occasionally hacked the VMM to
deliver VIRQ_DEBUG to Xen guests instead of that NMI. Mostly back when
I was busy being confused about ->vcpu_id vs. ->vcpu_idx vs. the
Xen/ACPI CPU# and where the hell my interrupts were going.

> > Along with the *actual* timer expiry,
> > which we need to extract/restore for LU/LM too, don't we?
> > /me nods
>=20
> I haven't thought that one well for Live Update / Live Migration, but
> I wonder if wouldn't be better to be instead a general 'xen state'
> attr type should you need more than just pending timers expiry. Albeit
> considering that the VMM has everything it needs (?), perhaps for Xen PV
> timer look to be the oddball missing, and we don=C2=BAt need to go that e=
xtent.

Yeah, the VMM knows most of this stuff already, as it *told* the kernel
in the first place. Userspace is still responsible for all the setup
and admin, and the kernel just handles the bare minimum of the fast
path.

So on live update/migrate we only really need to read out the runstate
data from the kernel... and now the current timer expiry.=20

On the *resume* side it's still lots of syscalls, and perhaps in the
end we might decide we want to do a KVM_XEN_HVM_SET_ATTR_MULTI which
takes an array of them? But I think that's a premature optimisation for
now.

--=-AnJglfCL3qBfRD4dOpmc
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
DQEHATAcBgkqhkiG9w0BCQUxDxcNMjIwMjEwMTUyMzEwWjAvBgkqhkiG9w0BCQQxIgQgkebllSov
g9ZC1GBo5VWdXBxMlC0GHVdKkJAMWOHuqTswgb0GCSsGAQQBgjcQBDGBrzCBrDCBljELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEYMBYG
A1UEChMPU2VjdGlnbyBMaW1pdGVkMT4wPAYDVQQDEzVTZWN0aWdvIFJTQSBDbGllbnQgQXV0aGVu
dGljYXRpb24gYW5kIFNlY3VyZSBFbWFpbCBDQQIRAMa+GZZnQMQDHShREvo7qX4wgb8GCyqGSIb3
DQEJEAILMYGvoIGsMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVy
MRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNl
Y3RpZ28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEAxr4Z
lmdAxAMdKFES+jupfjANBgkqhkiG9w0BAQEFAASCAgAlL5DkdEGnSO1AqN3BFE0AK/fozfS4ZsRk
teVftnOc2zIEeXfOwk4IPNbqP1dP45XSwnlJltzmTrAbue/fYN/ObAKAMnG9WS/Ymr8I4sIkwlFb
tvU4gnOheES33woOoCjDcUPvNSotJPTKoLgfqcwuv5uvayM+DVLfTmsWV9okR6k3pfwoJNCVm5O/
DYPx3wBPt9L1VTc9UGy7CGD1ShOheOQT9dEMYNpS1LoM8Mg/NJfH5imFcDkKzc7+Scjloam3jn1W
SA8Uc7xCWVxpER5THnP80gmpIq3EjdkGj/hBwt2zjI/lkWv6IvNKRkY5Lz8+iMAdeI4hZinAbHOp
r92k2PNd22iagmSBpLaMMfW/ruAc7aeb/CfybPpDIScR3ToCe6jCyMbQODUIa0VTa5A7bt8Yk8LB
8cVVxSC6yNcFmS7ZhEN7GBl47iqG4IYK7mizYxhM4dcFTZGw9acHrp1Y/lS1zxx6LPXKi03cBaFS
FhgK/4axHFsPQMjevTsGlYuRugnYGuFNsBMm38q6atW59fM7QprdPxSES2OatnJyEle7oRNPSH5w
jT9WX7H4zv/a/NpuRf7OhSslf+ZLekO/87IlhiXk6sCjWegWPq7F/uQTQGnNNSDs637K8pmY4vFI
gdkGSYt5HVGAwMS4uUxPCLBBNmvtyWTzifCGZJnXVAAAAAAAAA==


--=-AnJglfCL3qBfRD4dOpmc--

