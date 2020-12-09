Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E65102D3FDC
	for <lists+kvm@lfdr.de>; Wed,  9 Dec 2020 11:29:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729895AbgLIK20 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Dec 2020 05:28:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729885AbgLIK20 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Dec 2020 05:28:26 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4E92C061793;
        Wed,  9 Dec 2020 02:27:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Mime-Version:Content-Type:References:
        In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=+xC2SP2fl7JGy0vM1y0UHCv/orhgzQflCx8Fe0Fq8TQ=; b=PyWuGxjtvS4bGME27wBe1m6YIj
        SrbilRrVmX4AZdGjCIHknDfb+bhMSmdwRKLIc8KtiBNPQWwNE+nb0++EN/qlF5DNcwILC7DnlAtRY
        CHFIrJdtDa0wOhOYBZUkos9j1AVYGALItMJXMhRXdsJ/5k3mnvi6B39O3VzJZ1DdYSYlJXGzVR3TH
        OG8mms+MOj5Mg8r/eZr5eF6FzhpMC4adPDx9R0o4bGs6r36TirtcQdXN61uQ36i+PaW2HYTAsnvT6
        fzFHwNMU2TpnAJat/+1kiYXKuqXtS6awkYb3sblho8jsEJ3sMciuk4VFeCtQ3nCqv7j/hQskR/V5s
        B2JvFjeA==;
Received: from 54-240-197-224.amazon.com ([54.240.197.224] helo=freeip.amazon.com)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kmwgu-00085R-2m; Wed, 09 Dec 2020 10:27:24 +0000
Message-ID: <0eb8c2ef01b77af0d288888f200e812d374beada.camel@infradead.org>
Subject: Re: [PATCH RFC 10/39] KVM: x86/xen: support upcall vector
From:   David Woodhouse <dwmw2@infradead.org>
To:     Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>, karahmed@amazon.de
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?UTF-8?Q?Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 09 Dec 2020 10:27:21 +0000
In-Reply-To: <1af00fa4-03b8-a059-d859-5cfd71ef10f4@oracle.com>
References: <20190220201609.28290-1-joao.m.martins@oracle.com>
         <20190220201609.28290-11-joao.m.martins@oracle.com>
         <71753a370cd6f9dd147427634284073b78679fa6.camel@infradead.org>
         <53baeaa7-0fed-d22c-7767-09ae885d13a0@oracle.com>
         <4ad0d157c5c7317a660cd8d65b535d3232f9249d.camel@infradead.org>
         <c43024b3-6508-3b77-870c-da81e74284a4@oracle.com>
         <052867ae1c997487d85c21e995feb5647ac6c458.camel@infradead.org>
         <6a6b5806be1fe4c0fe96c0b664710d1ce614f29d.camel@infradead.org>
         <1af00fa4-03b8-a059-d859-5cfd71ef10f4@oracle.com>
Content-Type: multipart/signed; micalg="sha-256";
        protocol="application/x-pkcs7-signature";
        boundary="=-R2Dj/Lk/fpy7woodImlX"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by merlin.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-R2Dj/Lk/fpy7woodImlX
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2020-12-08 at 22:35 -0800, Ankur Arora wrote:
> > It looks like Linux doesn't use the per-vCPU upcall vector that you
> > called 'KVM_XEN_CALLBACK_VIA_EVTCHN'. So I'm delivering interrupts via
> > KVM_INTERRUPT as if they were ExtINT....
> >=20
> > ... except I'm not. Because the kernel really does expect that to be an
> > ExtINT from a legacy PIC, and kvm_apic_accept_pic_intr() only returns
> > true if LVT0 is set up for EXTINT and unmasked.
> >=20
> > I messed around with this hack and increasingly desperate variations on
> > the theme (since this one doesn't cause the IRQ window to be opened to
> > userspace in the first place), but couldn't get anything working:
>=20
> Increasingly desperate variations,  about sums up my process as well whil=
e
> trying to get the upcall vector working.

:)

So this seems to work, and I think it's about as minimal as it can get.

All it does is implement a kvm_xen_has_interrupt() which checks the
vcpu_info->evtchn_upcall_pending flag, just like Xen does.

With this, my completely userspace implementation of event channels is
working. And of course this forms a basis for adding the minimal
acceleration of IPI/VIRQ that we need to the kernel, too.

My only slight concern is the bit in vcpu_enter_guest() where we have
to add the check for kvm_xen_has_interrupt(), because nothing is
setting KVM_REQ_EVENT. I suppose I could look at having something =E2=80=94
even an explicit ioctl from userspace =E2=80=94 set that for us.... BUT...

I'm not sure that condition wasn't *already* broken some cases for
KVM_INTERRUPT anyway. In kvm_vcpu_ioctl_interrupt() we set
vcpu->arch.pending_userspace_vector and we *do* request KVM_REQ_EVENT,
sure.

But what if vcpu_enter_guest() processes that the first time (and
clears KVM_REQ_EVENT), and then exits for some *other* reason with
interrupts still disabled? Next time through vcpu_enter_guest(), even
though kvm_cpu_has_injectable_intr() is still true, we don't enable the
IRQ windowvmexit because KVM_REQ_EVENT got lost so we don't even call
inject_pending_event().

So instead of just kvm_xen_has_interrupt() in my patch below, I wonder
if we need to use kvm_cpu_has_injectable_intr() to fix the existing
bug? Or am I missing something there and there isn't a bug after all?

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_hos=
t.h
index d8716ef27728..4a63f212fdfc 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -902,6 +902,7 @@ struct msr_bitmap_range {
 /* Xen emulation context */
 struct kvm_xen {
 	bool long_mode;
+	u8 upcall_vector;
 	struct kvm_host_map shinfo_map;
 	void *shinfo;
 };
diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index 814698e5b152..24668b51b5c8 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -14,6 +14,7 @@
 #include "irq.h"
 #include "i8254.h"
 #include "x86.h"
+#include "xen.h"
=20
 /*
  * check if there are pending timer events
@@ -56,6 +57,9 @@ int kvm_cpu_has_extint(struct kvm_vcpu *v)
 	if (!lapic_in_kernel(v))
 		return v->arch.interrupt.injected;
=20
+	if (kvm_xen_has_interrupt(v))
+		return 1;
+
 	if (!kvm_apic_accept_pic_intr(v))
 		return 0;
=20
@@ -110,6 +114,9 @@ static int kvm_cpu_get_extint(struct kvm_vcpu *v)
 	if (!lapic_in_kernel(v))
 		return v->arch.interrupt.nr;
=20
+	if (kvm_xen_has_interrupt(v))
+		return v->kvm->arch.xen.upcall_vector;
+
 	if (irqchip_split(v->kvm)) {
 		int vector =3D v->arch.pending_external_vector;
=20
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ad9eea8f4f26..1711072b3616 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8891,7 +8891,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 			kvm_x86_ops.msr_filter_changed(vcpu);
 	}
=20
-	if (kvm_check_request(KVM_REQ_EVENT, vcpu) || req_int_win) {
+	if (kvm_check_request(KVM_REQ_EVENT, vcpu) || req_int_win ||
+	    kvm_xen_has_interrupt(vcpu)) {
 		++vcpu->stat.req_event;
 		kvm_apic_accept_events(vcpu);
 		if (vcpu->arch.mp_state =3D=3D KVM_MP_STATE_INIT_RECEIVED) {
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 4aa776c1ad57..116422d93d96 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -257,6 +257,22 @@ void kvm_xen_setup_pvclock_page(struct kvm_vcpu *v)
 	srcu_read_unlock(&v->kvm->srcu, idx);
 }
=20
+int kvm_xen_has_interrupt(struct kvm_vcpu *v)
+{
+       int rc =3D 0;
+
+       if (v->kvm->arch.xen.upcall_vector) {
+               int idx =3D srcu_read_lock(&v->kvm->srcu);
+               struct vcpu_info *vcpu_info =3D xen_vcpu_info(v);
+
+               if (vcpu_info && READ_ONCE(vcpu_info->evtchn_upcall_pending=
))
+                       rc =3D 1;
+
+               srcu_read_unlock(&v->kvm->srcu, idx);
+       }
+       return rc;
+}
+
 static int vcpu_attr_loc(struct kvm_vcpu *vcpu, u16 type,
 			 struct kvm_host_map **map, void ***hva, size_t *sz)
 {
@@ -338,6 +354,14 @@ int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_x=
en_hvm_attr *data)
 		break;
 	}
=20
+	case KVM_XEN_ATTR_TYPE_UPCALL_VECTOR:
+		if (data->u.vector < 0x10)
+			return -EINVAL;
+
+		kvm->arch.xen.upcall_vector =3D data->u.vector;
+		r =3D 0;
+		break;
+
 	default:
 		break;
 	}
@@ -386,6 +410,11 @@ int kvm_xen_hvm_get_attr(struct kvm *kvm, struct kvm_x=
en_hvm_attr *data)
 		break;
 	}
=20
+	case KVM_XEN_ATTR_TYPE_UPCALL_VECTOR:
+		data->u.vector =3D kvm->arch.xen.upcall_vector;
+		r =3D 0;
+		break;
+
 	default:
 		break;
 	}
diff --git a/arch/x86/kvm/xen.h b/arch/x86/kvm/xen.h
index ccd6002f55bc..1f599342f02c 100644
--- a/arch/x86/kvm/xen.h
+++ b/arch/x86/kvm/xen.h
@@ -25,6 +25,7 @@ static inline struct kvm_vcpu *xen_vcpu_to_vcpu(struct kv=
m_vcpu_xen *xen_vcpu)
 void kvm_xen_setup_pvclock_page(struct kvm_vcpu *vcpu);
 void kvm_xen_setup_runstate_page(struct kvm_vcpu *vcpu);
 void kvm_xen_runstate_set_preempted(struct kvm_vcpu *vcpu);
+int kvm_xen_has_interrupt (struct kvm_vcpu *vcpu);
 int kvm_xen_hvm_set_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data);
 int kvm_xen_hvm_get_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data);
 int kvm_xen_hypercall(struct kvm_vcpu *vcpu);
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 1047364d1adf..113279fa9e1e 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1587,6 +1587,7 @@ struct kvm_xen_hvm_attr {
=20
 	union {
 		__u8 long_mode;
+		__u8 vector;
 		struct {
 			__u64 gfn;
 		} shared_info;
@@ -1604,6 +1605,7 @@ struct kvm_xen_hvm_attr {
 #define KVM_XEN_ATTR_TYPE_VCPU_INFO		0x2
 #define KVM_XEN_ATTR_TYPE_VCPU_TIME_INFO	0x3
 #define KVM_XEN_ATTR_TYPE_VCPU_RUNSTATE		0x4
+#define KVM_XEN_ATTR_TYPE_UPCALL_VECTOR		0x5
=20
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {

--=-R2Dj/Lk/fpy7woodImlX
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCCECow
ggUcMIIEBKADAgECAhEA4rtJSHkq7AnpxKUY8ZlYZjANBgkqhkiG9w0BAQsFADCBlzELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgG
A1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhl
bnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0EwHhcNMTkwMTAyMDAwMDAwWhcNMjIwMTAxMjM1
OTU5WjAkMSIwIAYJKoZIhvcNAQkBFhNkd213MkBpbmZyYWRlYWQub3JnMIIBIjANBgkqhkiG9w0B
AQEFAAOCAQ8AMIIBCgKCAQEAsv3wObLTCbUA7GJqKj9vHGf+Fa+tpkO+ZRVve9EpNsMsfXhvFpb8
RgL8vD+L133wK6csYoDU7zKiAo92FMUWaY1Hy6HqvVr9oevfTV3xhB5rQO1RHJoAfkvhy+wpjo7Q
cXuzkOpibq2YurVStHAiGqAOMGMXhcVGqPuGhcVcVzVUjsvEzAV9Po9K2rpZ52FE4rDkpDK1pBK+
uOAyOkgIg/cD8Kugav5tyapydeWMZRJQH1vMQ6OVT24CyAn2yXm2NgTQMS1mpzStP2ioPtTnszIQ
Ih7ASVzhV6csHb8Yrkx8mgllOyrt9Y2kWRRJFm/FPRNEurOeNV6lnYAXOymVJwIDAQABo4IB0zCC
Ac8wHwYDVR0jBBgwFoAUgq9sjPjF/pZhfOgfPStxSF7Ei8AwHQYDVR0OBBYEFLfuNf820LvaT4AK
xrGK3EKx1DE7MA4GA1UdDwEB/wQEAwIFoDAMBgNVHRMBAf8EAjAAMB0GA1UdJQQWMBQGCCsGAQUF
BwMEBggrBgEFBQcDAjBGBgNVHSAEPzA9MDsGDCsGAQQBsjEBAgEDBTArMCkGCCsGAQUFBwIBFh1o
dHRwczovL3NlY3VyZS5jb21vZG8ubmV0L0NQUzBaBgNVHR8EUzBRME+gTaBLhklodHRwOi8vY3Js
LmNvbW9kb2NhLmNvbS9DT01PRE9SU0FDbGllbnRBdXRoZW50aWNhdGlvbmFuZFNlY3VyZUVtYWls
Q0EuY3JsMIGLBggrBgEFBQcBAQR/MH0wVQYIKwYBBQUHMAKGSWh0dHA6Ly9jcnQuY29tb2RvY2Eu
Y29tL0NPTU9ET1JTQUNsaWVudEF1dGhlbnRpY2F0aW9uYW5kU2VjdXJlRW1haWxDQS5jcnQwJAYI
KwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmNvbW9kb2NhLmNvbTAeBgNVHREEFzAVgRNkd213MkBpbmZy
YWRlYWQub3JnMA0GCSqGSIb3DQEBCwUAA4IBAQALbSykFusvvVkSIWttcEeifOGGKs7Wx2f5f45b
nv2ghcxK5URjUvCnJhg+soxOMoQLG6+nbhzzb2rLTdRVGbvjZH0fOOzq0LShq0EXsqnJbbuwJhK+
PnBtqX5O23PMHutP1l88AtVN+Rb72oSvnD+dK6708JqqUx2MAFLMevrhJRXLjKb2Mm+/8XBpEw+B
7DisN4TMlLB/d55WnT9UPNHmQ+3KFL7QrTO8hYExkU849g58Dn3Nw3oCbMUgny81ocrLlB2Z5fFG
Qu1AdNiBA+kg/UxzyJZpFbKfCITd5yX49bOriL692aMVDyqUvh8fP+T99PqorH4cIJP6OxSTdxKM
MIIFHDCCBASgAwIBAgIRAOK7SUh5KuwJ6cSlGPGZWGYwDQYJKoZIhvcNAQELBQAwgZcxCzAJBgNV
BAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAY
BgNVBAoTEUNPTU9ETyBDQSBMaW1pdGVkMT0wOwYDVQQDEzRDT01PRE8gUlNBIENsaWVudCBBdXRo
ZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBMB4XDTE5MDEwMjAwMDAwMFoXDTIyMDEwMTIz
NTk1OVowJDEiMCAGCSqGSIb3DQEJARYTZHdtdzJAaW5mcmFkZWFkLm9yZzCCASIwDQYJKoZIhvcN
AQEBBQADggEPADCCAQoCggEBALL98Dmy0wm1AOxiaio/bxxn/hWvraZDvmUVb3vRKTbDLH14bxaW
/EYC/Lw/i9d98CunLGKA1O8yogKPdhTFFmmNR8uh6r1a/aHr301d8YQea0DtURyaAH5L4cvsKY6O
0HF7s5DqYm6tmLq1UrRwIhqgDjBjF4XFRqj7hoXFXFc1VI7LxMwFfT6PStq6WedhROKw5KQytaQS
vrjgMjpICIP3A/CroGr+bcmqcnXljGUSUB9bzEOjlU9uAsgJ9sl5tjYE0DEtZqc0rT9oqD7U57My
ECIewElc4VenLB2/GK5MfJoJZTsq7fWNpFkUSRZvxT0TRLqznjVepZ2AFzsplScCAwEAAaOCAdMw
ggHPMB8GA1UdIwQYMBaAFIKvbIz4xf6WYXzoHz0rcUhexIvAMB0GA1UdDgQWBBS37jX/NtC72k+A
CsaxitxCsdQxOzAOBgNVHQ8BAf8EBAMCBaAwDAYDVR0TAQH/BAIwADAdBgNVHSUEFjAUBggrBgEF
BQcDBAYIKwYBBQUHAwIwRgYDVR0gBD8wPTA7BgwrBgEEAbIxAQIBAwUwKzApBggrBgEFBQcCARYd
aHR0cHM6Ly9zZWN1cmUuY29tb2RvLm5ldC9DUFMwWgYDVR0fBFMwUTBPoE2gS4ZJaHR0cDovL2Ny
bC5jb21vZG9jYS5jb20vQ09NT0RPUlNBQ2xpZW50QXV0aGVudGljYXRpb25hbmRTZWN1cmVFbWFp
bENBLmNybDCBiwYIKwYBBQUHAQEEfzB9MFUGCCsGAQUFBzAChklodHRwOi8vY3J0LmNvbW9kb2Nh
LmNvbS9DT01PRE9SU0FDbGllbnRBdXRoZW50aWNhdGlvbmFuZFNlY3VyZUVtYWlsQ0EuY3J0MCQG
CCsGAQUFBzABhhhodHRwOi8vb2NzcC5jb21vZG9jYS5jb20wHgYDVR0RBBcwFYETZHdtdzJAaW5m
cmFkZWFkLm9yZzANBgkqhkiG9w0BAQsFAAOCAQEAC20spBbrL71ZEiFrbXBHonzhhirO1sdn+X+O
W579oIXMSuVEY1LwpyYYPrKMTjKECxuvp24c829qy03UVRm742R9Hzjs6tC0oatBF7KpyW27sCYS
vj5wbal+TttzzB7rT9ZfPALVTfkW+9qEr5w/nSuu9PCaqlMdjABSzHr64SUVy4ym9jJvv/FwaRMP
gew4rDeEzJSwf3eeVp0/VDzR5kPtyhS+0K0zvIWBMZFPOPYOfA59zcN6AmzFIJ8vNaHKy5QdmeXx
RkLtQHTYgQPpIP1Mc8iWaRWynwiE3ecl+PWzq4i+vdmjFQ8qlL4fHz/k/fT6qKx+HCCT+jsUk3cS
jDCCBeYwggPOoAMCAQICEGqb4Tg7/ytrnwHV2binUlYwDQYJKoZIhvcNAQEMBQAwgYUxCzAJBgNV
BAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAY
BgNVBAoTEUNPTU9ETyBDQSBMaW1pdGVkMSswKQYDVQQDEyJDT01PRE8gUlNBIENlcnRpZmljYXRp
b24gQXV0aG9yaXR5MB4XDTEzMDExMDAwMDAwMFoXDTI4MDEwOTIzNTk1OVowgZcxCzAJBgNVBAYT
AkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAYBgNV
BAoTEUNPTU9ETyBDQSBMaW1pdGVkMT0wOwYDVQQDEzRDT01PRE8gUlNBIENsaWVudCBBdXRoZW50
aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKC
AQEAvrOeV6wodnVAFsc4A5jTxhh2IVDzJXkLTLWg0X06WD6cpzEup/Y0dtmEatrQPTRI5Or1u6zf
+bGBSyD9aH95dDSmeny1nxdlYCeXIoymMv6pQHJGNcIDpFDIMypVpVSRsivlJTRENf+RKwrB6vcf
WlP8dSsE3Rfywq09N0ZfxcBa39V0wsGtkGWC+eQKiz4pBZYKjrc5NOpG9qrxpZxyb4o4yNNwTqza
aPpGRqXB7IMjtf7tTmU2jqPMLxFNe1VXj9XB1rHvbRikw8lBoNoSWY66nJN/VCJv5ym6Q0mdCbDK
CMPybTjoNCQuelc0IAaO4nLUXk0BOSxSxt8kCvsUtQIDAQABo4IBPDCCATgwHwYDVR0jBBgwFoAU
u69+Aj36pvE8hI6t7jiY7NkyMtQwHQYDVR0OBBYEFIKvbIz4xf6WYXzoHz0rcUhexIvAMA4GA1Ud
DwEB/wQEAwIBhjASBgNVHRMBAf8ECDAGAQH/AgEAMBEGA1UdIAQKMAgwBgYEVR0gADBMBgNVHR8E
RTBDMEGgP6A9hjtodHRwOi8vY3JsLmNvbW9kb2NhLmNvbS9DT01PRE9SU0FDZXJ0aWZpY2F0aW9u
QXV0aG9yaXR5LmNybDBxBggrBgEFBQcBAQRlMGMwOwYIKwYBBQUHMAKGL2h0dHA6Ly9jcnQuY29t
b2RvY2EuY29tL0NPTU9ET1JTQUFkZFRydXN0Q0EuY3J0MCQGCCsGAQUFBzABhhhodHRwOi8vb2Nz
cC5jb21vZG9jYS5jb20wDQYJKoZIhvcNAQEMBQADggIBAHhcsoEoNE887l9Wzp+XVuyPomsX9vP2
SQgG1NgvNc3fQP7TcePo7EIMERoh42awGGsma65u/ITse2hKZHzT0CBxhuhb6txM1n/y78e/4ZOs
0j8CGpfb+SJA3GaBQ+394k+z3ZByWPQedXLL1OdK8aRINTsjk/H5Ns77zwbjOKkDamxlpZ4TKSDM
KVmU/PUWNMKSTvtlenlxBhh7ETrN543j/Q6qqgCWgWuMAXijnRglp9fyadqGOncjZjaaSOGTTFB+
E2pvOUtY+hPebuPtTbq7vODqzCM6ryEhNhzf+enm0zlpXK7q332nXttNtjv7VFNYG+I31gnMrwfH
M5tdhYF/8v5UY5g2xANPECTQdu9vWPoqNSGDt87b3gXb1AiGGaI06vzgkejL580ul+9hz9D0S0U4
jkhJiA7EuTecP/CFtR72uYRBcunwwH3fciPjviDDAI9SnC/2aPY8ydehzuZutLbZdRJ5PDEJM/1t
yZR2niOYihZ+FCbtf3D9mB12D4ln9icgc7CwaxpNSCPt8i/GqK2HsOgkL3VYnwtx7cJUmpvVdZ4o
gnzgXtgtdk3ShrtOS1iAN2ZBXFiRmjVzmehoMof06r1xub+85hFQzVxZx5/bRaTKTlL8YXLI8nAb
R9HWdFqzcOoB/hxfEyIQpx9/s81rgzdEZOofSlZHynoSMYIDyjCCA8YCAQEwga0wgZcxCzAJBgNV
BAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAY
BgNVBAoTEUNPTU9ETyBDQSBMaW1pdGVkMT0wOwYDVQQDEzRDT01PRE8gUlNBIENsaWVudCBBdXRo
ZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEA4rtJSHkq7AnpxKUY8ZlYZjANBglghkgB
ZQMEAgEFAKCCAe0wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMjAx
MjA5MTAyNzIxWjAvBgkqhkiG9w0BCQQxIgQg9W2Oc2jOX3gQkuM45Q27qi3BzYah7Lub8ANzoxZF
V4Uwgb4GCSsGAQQBgjcQBDGBsDCBrTCBlzELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIg
TWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQx
PTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1h
aWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMIHABgsqhkiG9w0BCRACCzGBsKCBrTCBlzELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgG
A1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhl
bnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMA0GCSqGSIb3
DQEBAQUABIIBAB+rnawI0owGsJrz827QVEsxte4pcEno6nRQHoBTpy0kReqqKlhTJtx0hiK99y17
LpnSgl9URdPzH8tJynC/BI1/WBhH2/uTuRMs1FBS9A/SFtu1iIkvuFcbVwkYlvSbm6I2XOrm5sga
y2L28kJ8sra8kuqySEuR2RN857BwdvVX+OOIYNWw2oEoOi1+IXWuLoVLF/yqRB6pTK5cj/aPohDV
y/7z2+kNr7bW2DtU2M9+G9sObzjmHXysp9euGtPG1tNEJkPTIkcS95F6WBUyzL/uoQuT6fzY1yOx
d8KnGwj6LBNHLVUpEcSVHINC2GRa2pkGkTflhEckKXbtLEFR8zoAAAAAAAA=


--=-R2Dj/Lk/fpy7woodImlX--

