Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C766F1B0A
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2019 17:20:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727491AbfKFQUc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Nov 2019 11:20:32 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:29460 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727275AbfKFQUb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Nov 2019 11:20:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573057230;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
        in-reply-to:in-reply-to:references:references:openpgp:openpgp:autocrypt:autocrypt;
        bh=NFPOc9egzkF4T9tFcctXrK0Z+Ky0DkKH6BjhbbeYREE=;
        b=aRdDrp3q/v8jtCGRMcbMknndpTJXq2XPIP+Gzwa34UkB+rPNPxV+N+naeu/OlfaDjMmx40
        CR+GYCx0kInN/eLTJ1BMiguL/c9owUc5MINyW1hr11KlVhZ73WCg62ZTXp9TTRD5ctnreo
        U/AgU3Fzq7h+00MUK6mV+uaplqSFBtg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-143-B8mNpyUGOS6YJ_VuaxiIdQ-1; Wed, 06 Nov 2019 11:20:25 -0500
X-MC-Unique: B8mNpyUGOS6YJ_VuaxiIdQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DE0FA8017E0;
        Wed,  6 Nov 2019 16:20:22 +0000 (UTC)
Received: from [10.18.17.163] (dhcp-17-163.bos.redhat.com [10.18.17.163])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 238475D713;
        Wed,  6 Nov 2019 16:20:18 +0000 (UTC)
Subject: Re: [Patch v1 2/2] KVM: x86: deliver KVM IOAPIC scan request to
 target vCPUs
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, mtosatti@redhat.com, rkrcmar@redhat.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org
References: <1573047398-7665-1-git-send-email-nitesh@redhat.com>
 <1573047398-7665-3-git-send-email-nitesh@redhat.com>
 <20191106151428.GB16249@linux.intel.com>
From:   Nitesh Narayan Lal <nitesh@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nitesh@redhat.com; prefer-encrypt=mutual; keydata=
 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
 VujM7c/b4pps
Organization: Red Hat Inc,
Message-ID: <eba0629f-243f-8f22-00a7-5ce8a0aa0394@redhat.com>
Date:   Wed, 6 Nov 2019 11:20:16 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191106151428.GB16249@linux.intel.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Mimecast-Spam-Score: 0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="melHcGqjiLGHtVEAO0URmFzfEJDcMEmCw"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--melHcGqjiLGHtVEAO0URmFzfEJDcMEmCw
Content-Type: multipart/mixed; boundary="LrLB0Ktl7wMOMuzP1FpFHI4JMewxHthDg";
 protected-headers="v1"
From: Nitesh Narayan Lal <nitesh@redhat.com>
To: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com,
 mtosatti@redhat.com, rkrcmar@redhat.com, vkuznets@redhat.com,
 wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org
Message-ID: <eba0629f-243f-8f22-00a7-5ce8a0aa0394@redhat.com>
Subject: Re: [Patch v1 2/2] KVM: x86: deliver KVM IOAPIC scan request to
 target vCPUs
References: <1573047398-7665-1-git-send-email-nitesh@redhat.com>
 <1573047398-7665-3-git-send-email-nitesh@redhat.com>
 <20191106151428.GB16249@linux.intel.com>
In-Reply-To: <20191106151428.GB16249@linux.intel.com>

--LrLB0Ktl7wMOMuzP1FpFHI4JMewxHthDg
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US


On 11/6/19 10:14 AM, Sean Christopherson wrote:
> On Wed, Nov 06, 2019 at 08:36:38AM -0500, Nitesh Narayan Lal wrote:
>> In IOAPIC fixed delivery mode instead of flushing the scan
>> requests to all vCPUs, we should only send the requests to
>> vCPUs specified within the destination field.
>>
>> This patch introduces kvm_get_dest_vcpus_mask() API which
>> retrieves an array of target vCPUs by using
>> kvm_apic_map_get_dest_lapic() and then based on the
>> vcpus_idx, it sets the bit in a bitmap. However, if the above
>> fails kvm_get_dest_vcpus_mask() finds the target vCPUs by
>> traversing all available vCPUs. Followed by setting the
>> bits in the bitmap.
>>
>> If we had different vCPUs in the previous request for the
>> same redirection table entry then bits corresponding to
>> these vCPUs are also set. This to done to keep
>> ioapic_handled_vectors synchronized.
>>
>> This bitmap is then eventually passed on to
>> kvm_make_vcpus_request_mask() to generate a masked request
>> only for the target vCPUs.
>>
>> This would enable us to reduce the latency overhead on isolated
>> vCPUs caused by the IPI to process due to KVM_REQ_IOAPIC_SCAN.
>>
>> Suggested-by: Marcelo Tosatti <mtosatti@redhat.com>
>> Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
>> ---
>>  arch/x86/include/asm/kvm_host.h |  2 ++
>>  arch/x86/kvm/ioapic.c           | 33 ++++++++++++++++++++++++++++--
>>  arch/x86/kvm/lapic.c            | 45 ++++++++++++++++++++++++++++++++++=
+++++++
>>  arch/x86/kvm/lapic.h            |  3 +++
>>  arch/x86/kvm/x86.c              |  6 ++++++
>>  include/linux/kvm_host.h        |  2 ++
>>  virt/kvm/kvm_main.c             | 14 +++++++++++++
>>  7 files changed, 103 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_=
host.h
>> index 24d6598..b2aca6d 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -1571,6 +1571,8 @@ int kvm_pv_send_ipi(struct kvm *kvm, unsigned long=
 ipi_bitmap_low,
>> =20
>>  void kvm_make_mclock_inprogress_request(struct kvm *kvm);
>>  void kvm_make_scan_ioapic_request(struct kvm *kvm);
>> +void kvm_make_scan_ioapic_request_mask(struct kvm *kvm,
>> +=09=09=09=09       unsigned long *vcpu_bitmap);
>> =20
>>  void kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
>>  =09=09=09=09     struct kvm_async_pf *work);
>> diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
>> index d859ae8..c8d0a83 100644
>> --- a/arch/x86/kvm/ioapic.c
>> +++ b/arch/x86/kvm/ioapic.c
>> @@ -271,8 +271,9 @@ static void ioapic_write_indirect(struct kvm_ioapic =
*ioapic, u32 val)
>>  {
>>  =09unsigned index;
>>  =09bool mask_before, mask_after;
>> -=09int old_remote_irr, old_delivery_status;
>>  =09union kvm_ioapic_redirect_entry *e;
>> +=09unsigned long vcpu_bitmap;
>> +=09int old_remote_irr, old_delivery_status, old_dest_id, old_dest_mode;
>> =20
>>  =09switch (ioapic->ioregsel) {
>>  =09case IOAPIC_REG_VERSION:
>> @@ -296,6 +297,8 @@ static void ioapic_write_indirect(struct kvm_ioapic =
*ioapic, u32 val)
>>  =09=09/* Preserve read-only fields */
>>  =09=09old_remote_irr =3D e->fields.remote_irr;
>>  =09=09old_delivery_status =3D e->fields.delivery_status;
>> +=09=09old_dest_id =3D e->fields.dest_id;
>> +=09=09old_dest_mode =3D e->fields.dest_mode;
>>  =09=09if (ioapic->ioregsel & 1) {
>>  =09=09=09e->bits &=3D 0xffffffff;
>>  =09=09=09e->bits |=3D (u64) val << 32;
>> @@ -321,7 +324,33 @@ static void ioapic_write_indirect(struct kvm_ioapic=
 *ioapic, u32 val)
>>  =09=09if (e->fields.trig_mode =3D=3D IOAPIC_LEVEL_TRIG
>>  =09=09    && ioapic->irr & (1 << index))
>>  =09=09=09ioapic_service(ioapic, index, false);
>> -=09=09kvm_make_scan_ioapic_request(ioapic->kvm);
>> +=09=09if (e->fields.delivery_mode =3D=3D APIC_DM_FIXED) {
>> +=09=09=09struct kvm_lapic_irq irq;
>> +
>> +=09=09=09irq.shorthand =3D 0;
>> +=09=09=09irq.vector =3D e->fields.vector;
>> +=09=09=09irq.delivery_mode =3D e->fields.delivery_mode << 8;
>> +=09=09=09irq.dest_id =3D e->fields.dest_id;
>> +=09=09=09irq.dest_mode =3D e->fields.dest_mode;
>> +=09=09=09kvm_get_dest_vcpus_mask(ioapic->kvm, &irq,
>> +=09=09=09=09=09=09&vcpu_bitmap);
>> +=09=09=09if (old_dest_mode !=3D e->fields.dest_mode ||
>> +=09=09=09    old_dest_id !=3D e->fields.dest_id) {
>> +=09=09=09=09/*
>> +=09=09=09=09 * Update vcpu_bitmap with vcpus specified in
>> +=09=09=09=09 * the previous request as well. This is done to
>> +=09=09=09=09 * keep ioapic_handled_vectors synchronized.
>> +=09=09=09=09 */
>> +=09=09=09=09irq.dest_id =3D old_dest_id;
>> +=09=09=09=09irq.dest_mode =3D old_dest_mode;
>> +=09=09=09=09kvm_get_dest_vcpus_mask(ioapic->kvm, &irq,
>> +=09=09=09=09=09=09=09&vcpu_bitmap);
>> +=09=09=09}
>> +=09=09=09kvm_make_scan_ioapic_request_mask(ioapic->kvm,
>> +=09=09=09=09=09=09=09  &vcpu_bitmap);
>> +=09=09} else {
>> +=09=09=09kvm_make_scan_ioapic_request(ioapic->kvm);
>> +=09=09}
>>  =09=09break;
>>  =09}
>>  }
>> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
>> index b29d00b..90869c4 100644
>> --- a/arch/x86/kvm/lapic.c
>> +++ b/arch/x86/kvm/lapic.c
>> @@ -1124,6 +1124,51 @@ static int __apic_accept_irq(struct kvm_lapic *ap=
ic, int delivery_mode,
>>  =09return result;
>>  }
>> =20
>> +/*
>> + * This routine identifies the destination vcpus mask meant to receive =
the
>> + * IOAPIC interrupts. It either uses kvm_apic_map_get_dest_lapic() to f=
ind
>> + * out the destination vcpus array and set the bitmap or it traverses t=
o
>> + * each available vcpu to identify the same.
>> + */
>> +void kvm_get_dest_vcpus_mask(struct kvm *kvm, struct kvm_lapic_irq *irq=
,
>> +=09=09=09     unsigned long *vcpu_bitmap)
>> +{
>> +=09struct kvm_lapic **dest_vcpu =3D NULL;
>> +=09struct kvm_lapic *src =3D NULL;
>> +=09struct kvm_apic_map *map;
>> +=09struct kvm_vcpu *vcpu;
>> +=09unsigned long bitmap;
>> +=09int i, vcpus_idx;
>> +=09bool ret;
>> +
>> +=09rcu_read_lock();
>> +=09map =3D rcu_dereference(kvm->arch.apic_map);
>> +
>> +=09ret =3D kvm_apic_map_get_dest_lapic(kvm, &src, irq, map, &dest_vcpu,
>> +=09=09=09=09=09  &bitmap);
>> +=09if (ret) {
>> +=09=09for_each_set_bit(i, &bitmap, 16) {
>> +=09=09=09if (!dest_vcpu[i])
>> +=09=09=09=09continue;
>> +=09=09=09vcpus_idx =3D dest_vcpu[i]->vcpu->vcpus_idx;
>> +=09=09=09__set_bit(vcpus_idx, vcpu_bitmap);
>> +=09=09}
>> +=09} else {
>> +=09=09kvm_for_each_vcpu(i, vcpu, kvm) {
>> +=09=09=09if (!kvm_apic_present(vcpu))
>> +=09=09=09=09continue;
>> +=09=09=09if (!kvm_apic_match_dest(vcpu, NULL,
>> +=09=09=09=09=09=09 irq->delivery_mode,
>> +=09=09=09=09=09=09 irq->dest_id,
>> +=09=09=09=09=09=09 irq->dest_mode))
>> +=09=09=09=09continue;
>> +=09=09=09vcpus_idx =3D dest_vcpu[i]->vcpu->vcpus_idx;
> This can't possibly be correct.  AFAICT, dest_vcpu is guaranteed to be
> *NULL* when kvm_apic_map_get_dest_lapic() returns false, and on top of
> that I'm pretty sure it's not intended to be indexed by the vcpu index.
>
> But vcpus_idx isn't needed here, you already have @vcpu, and even that
> is superfluous as @i itself is the vcpu index.

Yeah, its a bug. I will correct it.

>
> It's probably worth manually testing this path by forcing @ret to false,
> I'm guessing it's not being hit in normal operation.

Sure, good idea.

>
>> +=09=09=09__set_bit(vcpus_idx, vcpu_bitmap);
>> +=09=09}
>> +=09}
>> +=09rcu_read_unlock();
>> +}
>> +
>>  int kvm_apic_compare_prio(struct kvm_vcpu *vcpu1, struct kvm_vcpu *vcpu=
2)
>>  {
>>  =09return vcpu1->arch.apic_arb_prio - vcpu2->arch.apic_arb_prio;
>> diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
>> index 1f501485..49b0c6c 100644
>> --- a/arch/x86/kvm/lapic.h
>> +++ b/arch/x86/kvm/lapic.h
>> @@ -226,6 +226,9 @@ static inline int kvm_lapic_latched_init(struct kvm_=
vcpu *vcpu)
>> =20
>>  void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu);
>> =20
>> +void kvm_get_dest_vcpus_mask(struct kvm *kvm, struct kvm_lapic_irq *irq=
,
>> +=09=09=09     unsigned long *vcpu_bitmap);
>> +
>>  bool kvm_intr_is_single_vcpu_fast(struct kvm *kvm, struct kvm_lapic_irq=
 *irq,
>>  =09=09=09struct kvm_vcpu **dest_vcpu);
>>  int kvm_vector_to_index(u32 vector, u32 dest_vcpus,
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index ff395f8..ee6945f 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -7838,6 +7838,12 @@ static void process_smi(struct kvm_vcpu *vcpu)
>>  =09kvm_make_request(KVM_REQ_EVENT, vcpu);
>>  }
>> =20
>> +void kvm_make_scan_ioapic_request_mask(struct kvm *kvm,
>> +=09=09=09=09       unsigned long *vcpu_bitmap)
>> +{
>> +=09kvm_make_cpus_request_mask(kvm, KVM_REQ_SCAN_IOAPIC, vcpu_bitmap);
>> +}
>> +
>>  void kvm_make_scan_ioapic_request(struct kvm *kvm)
>>  {
>>  =09kvm_make_all_cpus_request(kvm, KVM_REQ_SCAN_IOAPIC);
>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>> index 31c4fde..2f69eae 100644
>> --- a/include/linux/kvm_host.h
>> +++ b/include/linux/kvm_host.h
>> @@ -786,6 +786,8 @@ int kvm_vcpu_write_guest(struct kvm_vcpu *vcpu, gpa_=
t gpa, const void *data,
>>  bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
>>  =09=09=09=09 unsigned long *vcpu_bitmap, cpumask_var_t tmp);
>>  bool kvm_make_all_cpus_request(struct kvm *kvm, unsigned int req);
>> +bool kvm_make_cpus_request_mask(struct kvm *kvm, unsigned int req,
>> +=09=09=09=09unsigned long *vcpu_bitmap);
>> =20
>>  long kvm_arch_dev_ioctl(struct file *filp,
>>  =09=09=09unsigned int ioctl, unsigned long arg);
>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>> index 24ab711..9e85df8 100644
>> --- a/virt/kvm/kvm_main.c
>> +++ b/virt/kvm/kvm_main.c
>> @@ -242,6 +242,20 @@ bool kvm_make_vcpus_request_mask(struct kvm *kvm, u=
nsigned int req,
>>  =09return called;
>>  }
>> =20
>> +bool kvm_make_cpus_request_mask(struct kvm *kvm, unsigned int req,
>> +=09=09=09=09unsigned long *vcpu_bitmap)
>> +{
>> +=09cpumask_var_t cpus;
>> +=09bool called;
>> +
>> +=09zalloc_cpumask_var(&cpus, GFP_ATOMIC);
>> +
>> +=09called =3D kvm_make_vcpus_request_mask(kvm, req, vcpu_bitmap, cpus);
>> +
>> +=09free_cpumask_var(cpus);
>> +=09return called;
> kvm_make_all_cpus_request() should call this new function, the code is
> identical except for its declared vcpu_bitmap. =20

I was also skeptical about this particular change.
The other way I thought of doing this was by modifying the definition of
kvm_make_all_cpus_request(). But I was not sure if that is a good idea as i=
t
would have required more changes in the existing code.

>> +}
>> +
>>  bool kvm_make_all_cpus_request(struct kvm *kvm, unsigned int req)
>>  {
>>  =09cpumask_var_t cpus;
>> --=20
>> 1.8.3.1
>>
--=20
Thanks
Nitesh


--LrLB0Ktl7wMOMuzP1FpFHI4JMewxHthDg--

--melHcGqjiLGHtVEAO0URmFzfEJDcMEmCw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIyBAEBCAAdFiEEkXcoRVGaqvbHPuAGo4ZA3AYyozkFAl3C8sEACgkQo4ZA3AYy
oznAMg/4oYQvq6qNVHi5b6d/yYIXM702uKcv6aLBO8LxEDjXdXYYsqYdNu7gAv7F
4yroyMQPrLIDJ/794TtiqU2Vu94f/UOAck/CA9vNPNhWmYgbBfKxHXq49t/dCGmh
I7RT5jN9ThIBRZOC0AeJoVapdXyq1ZW9joNU80AAA3T66NfmkJq9LHabWReATbd6
NjOxIPgNAriY6Om7U6E2a1KT4v/G0xoV0+P7K9ygTOYdjpV7T8VzL1xD33yjwQTl
w0n+5q0GmIyGasGnCt+eDGlMzTGfgWRgobwz+VXFIwZiBYXJaqu56pNkQbyLN0E+
X7KcU3RBDvHc7DhJIDStQs5iKRY1m/UAAhFrsbb0VhrTYGNBK0TSkXISL+67uNC5
cGOZfXcJ0WOmfTk0noGlAV313MHlcNRvKoj6NNdUqEnOHuMNDUVaMzL/NetxtqJp
ozYtmqOo3mdqk6pdbGmSm3iBVZJwE7YNJE9jBes0AvSG+K5lW3WBqzyByjxEmnkk
ydcsWrbDMNF00yEXRiqS8zGM5539SZkXZWy+cXjJwggPmoQKRdpbULxGWEHdFUND
5QG5zXSKwBW2RPIn81X7wTMWKp3HrSqvS5eQWk87QKB7WgdfzWSDywfjwqbVL1CV
B+mxVSKmi3iH7xid0tD77Z3LnP3fiA6js3RMYjrlDgoVzxwpRg==
=BOYw
-----END PGP SIGNATURE-----

--melHcGqjiLGHtVEAO0URmFzfEJDcMEmCw--

