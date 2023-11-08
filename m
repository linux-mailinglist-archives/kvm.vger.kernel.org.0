Return-Path: <kvm+bounces-1211-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D45AD7E59F5
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 16:25:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 027CC1C20B94
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 15:25:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B43DC30343;
	Wed,  8 Nov 2023 15:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DKpa94mn"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84E06171C6
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 15:25:33 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 572031BF7;
	Wed,  8 Nov 2023 07:25:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=gYPXBFEcbjM8UetvyGMAox92A6KCFDsiwE+M6KoIx0w=; b=DKpa94mnD7761BbjSTQiP8E8W/
	DWPfhJdISfPJf4yoKjq9ufGEln/k7vZKqGJGNtmuoluXfaeQXUzXPzJAkUg3/5Pqseq4OCVt/UA5U
	tfv0njvZVps49xWl3llqGasKN+Wwvn32JOPX3FZcyk0UEQunR9bx4sMvBtwndBChrEDewp7UWjefX
	tuzdWmBCf0O86gzKS8LFEZIZqQP39kgQeFEejjruA+h/LtNrgfvZBv/B2byomOYmQJIAWvykv9H2U
	/vomngekFNLfJtBiqk2W4AWugLgLB1sqo5sq3mzmrm2f7D2O/dji7frTKMVB5dmXsCLjSq+uey8UB
	f4JPyEDQ==;
Received: from [2001:8b0:10b:5:8c2f:562b:3c9a:b5d5] (helo=u3832b3a9db3152.ant.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1r0kQr-001knj-Qe; Wed, 08 Nov 2023 15:25:30 +0000
Message-ID: <5e0598c86361570674401f43191c3f819a6b32d2.camel@infradead.org>
Subject: Re: [PATCH v2] KVM: x86/xen: improve accuracy of Xen timers
From: David Woodhouse <dwmw2@infradead.org>
To: Dongli Zhang <dongli.zhang@oracle.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Cc: Paul Durrant <paul@xen.org>, Sean Christopherson <seanjc@google.com>, 
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>,  Borislav Petkov <bp@alien8.de>, Dave
 Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin"
 <hpa@zytor.com>
Date: Wed, 08 Nov 2023 15:25:29 +0000
In-Reply-To: <33907a83-4e1a-f121-74f3-bde1e68b047c@oracle.com>
References: <96da7273adfff2a346de9a4a27ce064f6fe0d0a1.camel@infradead.org>
	 <74f32bfae7243a78d0e74b1ba3a2d1ea4a4a7518.camel@infradead.org>
	 <2bd5d543-08a0-a0f6-0f59-b8724a2d8d75@oracle.com>
	 <12e8ade22fe6c1e6bec74e60e8213302a7da635e.camel@infradead.org>
	 <19f8de0a-17f7-1a25-f2e9-adbf00ecb035@oracle.com>
	 <37225cb2ab45c842275c2b5b5d84d1bb514a8640.camel@infradead.org>
	 <33907a83-4e1a-f121-74f3-bde1e68b047c@oracle.com>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-smuUMfsW8xU8lAzTM98r"
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html


--=-smuUMfsW8xU8lAzTM98r
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2023-11-07 at 17:43 -0800, Dongli Zhang wrote:
> Hi David,
>=20
> On 11/7/23 15:24, David Woodhouse wrote:
> > On Tue, 2023-11-07 at 15:07 -0800, Dongli Zhang wrote:
> > > Thank you very much for the detailed explanation.
> > >=20
> > > I agree it is important to resolve the "now" problem. I guess the KVM=
 lapic
> > > deadline timer has the "now" problem as well.
> >=20
> > I think so. And quite gratuitously so, since it just does:
> >=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0now =3D ktime_get();
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0guest_tsc =3D kvm_read_=
l1_tsc(vcpu, rdtsc());
> >=20
> >=20
> > Couldn't that trivially be changed to kvm_get_monotonic_and_clockread()=
?
>=20
> The core idea is to always capture the pair of (tsc, ns) at exactly the s=
ame
> time point.
>=20
> I have no idea how much accuracy it can improve, considering the extra co=
sts to
> inject the timer interrupt into the vCPU.

Right. It's probably in the noise most of the time, unless you're
unlucky enough to get preempted between the two TSC reads which are
supposed to be happening "at the same time".
>=20

> > I conveniently ducked this question in my patch by only supporting the
> > CONSTANT_TSC case, and not the case where we happen to know the
> > (potentially different) TSC frequencies on all the different pCPUs and
> > vCPUs.
>=20
> This is also my question that why to support only the CONSTANT_TSC case.
>=20
> For the lapic timer case:
>=20
> The timer is always calculated based on the *current* vCPU's tsc virtuali=
zation,
> regardless CONSTANT_TSC or not.
>=20
> For the xen timer case:
>=20
> Why not always calculate the expire based on the *current* vCPU's time
> virtualization? That is, why not always use the current vCPU's hv_clock,
> regardless CONSTANT_TSC/masteclock?

The simple answer is because I wasn't sure it would work correctly in
all cases, and didn't *care* enough about the non-CONSTANT_TSC case to
prove it to myself.

Let's think about it...

In the non-CONSTANT_TSC case, each physical CPU can have a different
TSC frequency, yes? And KVM has a cpufreq notifier which triggers when
the TSC changes, and make a KVM_REQ_CLOCK_UPDATE request to any vCPU
running on the affected pCPU. With an associated IPI to ensure the vCPU
exits guest mode and will processes the update before executing any
further guest code.

If a vCPU had *previously* been running on the affected pCPU but wasn't
running when the notifier happened, then kvm_arch_vcpu_load() will make
a KVM_REQ_GLOBAL_CLOCK_UPDATE request, which will immediately update
the vCPU in question, and then trigger a deferred KVM_REQ_CLOCK_UPDATE
for the others.

So the vCPU itself, in guest mode, is always going to see *correct*
pvclock information corresponding to the pCPU it is running on at the
time.

(I *believe* the way this works is that when a vCPU runs on a pCPU
which has a TSC frequency lower than the vCPU should have, it runs in
'always catchup' mode. Where the TSC offset is bumped *every* time the
vCPU enters guest mode, so the TSC is about right on every entry, might
seem to run a little slow if the vCPU does a tight loop of rdtsc, but
will catch up again on next vmexit/entry?)

But we aren't talking about the vCPU running in guest mode. The code in
kvm_xen_start_timer() and in start_sw_tscdeadline() is running in the
host kernel. How can we be sure that it's running on the *same*
physical CPU that the vCPU was previously running on, and thus how can
we be sure that the vcpu->arch.hv_clock is valid with respect to a
rdtsc on the current pCPU? I don't know that we can know that.

As far as I can tell, the code in start_sw_tscdeadline() makes no
attempt to do the 'catchup' thing, and just converts the pCPU's TSC to
guest TSC using kvm_read_l1_tsc() =E2=80=94 which uses a multiplier that's =
set
once and *never* recalculated when the host TSC frequency changes.

On the whole, now I *have* thought about it, I'm even more convinced I
was right in the first place that I didn't want to know :)

I think I stand by my original decision that the Xen timer code in the
non-CONSTANT_TSC case can just use get_kvmclock_ns(). The "now" problem
is going to be in the noise if the TSC isn't constant anyway, and we
need to fix the drift and jumps of=C2=A0get_kvmclock_ns() *anyway* rather
than adding a temporary special case for the Xen timers.

> That is: kvm lapic method with kvm_get_monotonic_and_clockread().
>=20
> >=20
> >=20
> > >=20
> > > E.g., according to the KVM lapic deadline timer, all values are based=
 on (1) the
> > > tsc value, (2)on the current vCPU.
> > >=20
> > >=20
> > > 1949 static void start_sw_tscdeadline(struct kvm_lapic *apic)
> > > 1950 {
> > > 1951=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct kvm_timer=
 *ktimer =3D &apic->lapic_timer;
> > > 1952=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 guest_tsc, t=
scdeadline =3D ktimer->tscdeadline;
> > > 1953=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 ns =3D 0;
> > > 1954=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ktime_t expire;
> > > 1955=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct kvm_vcpu =
*vcpu =3D apic->vcpu;
> > > 1956=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned long th=
is_tsc_khz =3D vcpu->arch.virtual_tsc_khz;
> > > 1957=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned long fl=
ags;
> > > 1958=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ktime_t now;
> > > 1959
> > > 1960=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (unlikely(!ts=
cdeadline || !this_tsc_khz))
> > > 1961=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return;
> > > 1962
> > > 1963=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 local_irq_save(f=
lags);
> > > 1964
> > > 1965=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 now =3D ktime_ge=
t();
> > > 1966=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 guest_tsc =3D kv=
m_read_l1_tsc(vcpu, rdtsc());
> > > 1967
> > > 1968=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ns =3D (tscdeadl=
ine - guest_tsc) * 1000000ULL;
> > > 1969=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 do_div(ns, this_=
tsc_khz);
> > >=20
> > >=20
> > > Sorry if I make the question very confusing. The core question is: wh=
ere and
> > > from which clocksource the abs nanosecond value is from? What will ha=
ppen if the
> > > Xen VM uses HPET as clocksource, while xen timer as clock event?
> >=20
> > If the guest uses HPET as clocksource and Xen timer as clockevents,
> > then keeping itself in sync is the *guest's* problem. The Xen timer is
> > defined in terms of nanoseconds since guest start, as provided in the
> > pvclock information described above. Hope that helps!
> >=20
>=20
> The "in terms of nanoseconds since guest start" refers to *one* global va=
lue.
> Should we use wallclock when we are referring to a global value shared by=
 all vCPUs?
>=20
>=20
> Based on the following piece of code, I do not think we may assume all vC=
PUs
> have the same pvclock at the same time point: line 104-108, when
> PVCLOCK_TSC_STABLE_BIT is not set.
>=20

The *result* of calculating the pvclock should be the same on all vCPUs
at any given moment in time.

The precise *calculation* may differ, depending on the frequency of the
TSC for that particular vCPU and the last time the pvclock information
was created for that vCPU.


>=20
> =C2=A067 static __always_inline
> =C2=A068 u64 __pvclock_clocksource_read(struct pvclock_vcpu_time_info *sr=
c, bool dowd)
> =C2=A069 {
> =C2=A070=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned version=
;
> =C2=A071=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 ret;
> =C2=A072=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 last;
> =C2=A073=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u8 flags;
> =C2=A074
> =C2=A075=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 do {
> =C2=A076=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 version =3D pvclock_read_begin(src);
> =C2=A077=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D __pvclock_read_cycles(src, rdtsc_=
ordered());
> =C2=A078=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 flags =3D src->flags;
> =C2=A079=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 } while (pvclock=
_read_retry(src, version));
> ... ...
> 104=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 last =3D raw_atomic64=
_read(&last_value);
> 105=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 do {
> 106=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret <=3D last)
> 107=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 return last;
> 108=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 } while (!raw_atomic6=
4_try_cmpxchg(&last_value, &last, ret));
> 109
> 110=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return ret;
> 111 }
>=20
>=20
> That's why I appreciate a definition of the abs nanoseconds used by the x=
en
> timer (e.g., derived from pvclock). If it is per-vCPU, we may not use it =
for a
> global "in terms of nanoseconds since guest start", when PVCLOCK_TSC_STAB=
LE_BIT
> is not set.

It is only per-vCPU if the vCPUs have *different* TSC frequencies.
That's because of the scaling; the guest calculates the nanoseconds
from the *guest* TSC of course, scaled according to the pvclock
information given to the guest by KVM.

As discussed and demonstrated by http://david.woodhou.se/tsdrift.c , if
KVM scales directly to nanoseconds from the *host* TSC at its known
frequency, that introduces a systemic drift between what the guest
calculates, and what KVM calculates =E2=80=94 even in the CONSTANT_TSC case=
.

How do we reconcile the two? Well, it makes no sense for the definition
of the pvclock to be something that the guest *cannot* calculate, so
obviously KVM must do the same calculations the guest does; scale to
the guest TSC (kvm_read_l1_tsc()) and then apply the same pvclock
information from vcpu->arch.hvclock to get the nanoseconds.

In the sane world where the guest vCPUs all have the *same* TSC
frequency, that's fine. The kvmclock isn't *really* per-vCPU because
they're all the same.=20

If the VMM sets up different vCPUs to have different TSC frequencies
then yes, their kvmclock will drift slightly apart over time. That
might be the *one* case where I will accept that the guest pvclock
might ever change, even in the CONSTANT_TSC environment (without host
suspend or any other nonsense).

In that patch I started typing on Monday and *still* haven't got round
to finishing because other things keep catching fire, I'm using the
*KVM-wide* guest TSC frequency as the definition for the kvmclock.



--=-smuUMfsW8xU8lAzTM98r
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
DQEHATAcBgkqhkiG9w0BCQUxDxcNMjMxMTA4MTUyNTI5WjAvBgkqhkiG9w0BCQQxIgQgNxzQWw1H
5uK6QyFcFJZ0X3UTK7Bz5papwVMwURzefT8wgb0GCSsGAQQBgjcQBDGBrzCBrDCBljELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEYMBYG
A1UEChMPU2VjdGlnbyBMaW1pdGVkMT4wPAYDVQQDEzVTZWN0aWdvIFJTQSBDbGllbnQgQXV0aGVu
dGljYXRpb24gYW5kIFNlY3VyZSBFbWFpbCBDQQIRAMa+GZZnQMQDHShREvo7qX4wgb8GCyqGSIb3
DQEJEAILMYGvoIGsMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVy
MRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNl
Y3RpZ28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEAxr4Z
lmdAxAMdKFES+jupfjANBgkqhkiG9w0BAQEFAASCAgCcqK0Ysw+/Fs0RZETdto/pVREGWldtODKR
XnaP6xebDH05DflIWkaRoUAdXyr2aDRhw5HHmhC27Y5EYnuT/QJ/3aUpsVqKmlQ3s9Z6SdpjHw4H
Ja4oBlXdLJYbthQl76EUNdxT++RIOlSBNNhNMBKqfSWkwFZdebL/GdlEKNyr8uq7qyMrBFlZCpPA
FDjPry3cwIVCxFQ3giAOc5n3mjvLDoO9BWbXNgOm9yVVHJ7GLm3vwRhI8QRl5fEccH6NiOJvAcDk
voO2WUbaznLaDtPZ7gZWwWKxw85FnU2b+sawDpZR9WnFyBMG8yQfq39G/cHCJ7Uraa2gMVaDSEsW
zqiNH8903BF313e6CZn4iv9zt0807w7ukalOOURSKTam63XjaaBhNfL5GngRepBFZtxKemwZRROY
9nZu6FQL9tDmPVcYnkFj93+ux7HxTGc5FYXCOSRLTzN+0shn4rRme5CKxIRGplivbx9UKiYsuWtf
fU627fDyS9wY185v1liBkwCFAI2xAi8bzZZwbTGNcCFmzHinzUSqk28ku36tpRxi09qmIm308qBc
YZfZC+IhiCaKE4qXSkWc4IDM4RQR+qiDXfwa73TpYg3GyXg6Lh2XYvxisVvWGvbdS3CsMYEWHdvd
qE+zw7+XYDcjChxknMXRaxAulzqsRwvnFCGYVhWlxQAAAAAAAA==


--=-smuUMfsW8xU8lAzTM98r--

