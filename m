Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFD9E28BD3B
	for <lists+kvm@lfdr.de>; Mon, 12 Oct 2020 18:06:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390410AbgJLQGu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Oct 2020 12:06:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389068AbgJLQGs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Oct 2020 12:06:48 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB072C0613D0;
        Mon, 12 Oct 2020 09:06:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Mime-Version:Content-Type:References:
        In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=RnyKZcdXkavntB3jVv6ADjR/Rxxto4TuxDYQbc/EtM8=; b=BSfEZcJjSbINrCoymH94WhqIlK
        yODpw+jCxES2PXg9ouDqjd/pV6Oa7ayZf2h+VsKYuU82MmZMI8ziXZHicSYmFVIGminxkZ2SlxM0p
        xIbOOWKUtzyFAZ2q03lFkZtMO95MZ8yRAmIayy4Ks+PX49eaExgXpojLjFWvdecD6PNso7ozY97K5
        IUcMvMDcvQWesx0ZhknjLGgGpeOcVCmCJHdWrDBRiNqfuuj6lD5EVYgyomH4w3MwxIydl+zEscROc
        QZ6ff69ulnww6+OzAT6d6rOrB5Dd873DrEjK6b1AG9gkkujRFKHPEysJzEu21AybVdAo3T5wo9ifW
        edbfG46w==;
Received: from 54-240-197-232.amazon.com ([54.240.197.232] helo=freeip.amazon.com)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kS0LT-0007hi-EI; Mon, 12 Oct 2020 16:06:43 +0000
Message-ID: <25c54f8e5da1fd5cf3b01ad2fdc1640c5d86baa1.camel@infradead.org>
Subject: Re: [PATCH 5/5] x86/kvm: Add KVM_FEATURE_MSI_EXT_DEST_ID
From:   David Woodhouse <dwmw2@infradead.org>
To:     Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Marc Zyngier <maz@kernel.org>
Cc:     kvm <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Mon, 12 Oct 2020 17:06:41 +0100
In-Reply-To: <87ft6jrdpk.fsf@nanos.tec.linutronix.de>
References: <803bb6b2212e65c568c84ff6882c2aa8a0ee03d5.camel@infradead.org>
         <20201007122046.1113577-1-dwmw2@infradead.org>
         <20201007122046.1113577-5-dwmw2@infradead.org>
         <87blhcx6qz.fsf@nanos.tec.linutronix.de>
         <f27b17cf4ab64fdb4f14a056bd8c6a93795d9a85.camel@infradead.org>
         <95625dfce360756b99641c31212634c1bf80a69a.camel@infradead.org>
         <87362owhcb.fsf@nanos.tec.linutronix.de>
         <c6f21628733cac23fd28679842c20423df2dd423.camel@infradead.org>
         <87tuv4uwmt.fsf@nanos.tec.linutronix.de>
         <958f0d5c9844f94f2ce47a762c5453329b9e737e.camel@infradead.org>
         <874kn2s3ud.fsf@nanos.tec.linutronix.de>
         <0E51DAB1-5973-4226-B127-65D77DC46CB5@infradead.org>
         <87pn5or8k7.fsf@nanos.tec.linutronix.de>
         <F0F0A646-8DBA-4448-933F-993A3335BD59@infradead.org>
         <87ft6jrdpk.fsf@nanos.tec.linutronix.de>
Content-Type: multipart/signed; micalg="sha-256";
        protocol="application/x-pkcs7-signature";
        boundary="=-FZJqNo/G0THb9yJ11szo"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by merlin.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-FZJqNo/G0THb9yJ11szo
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2020-10-12 at 11:33 +0200, Thomas Gleixner wrote:
> On Sun, Oct 11 2020 at 22:15, David Woodhouse wrote:
> > On 11 October 2020 18:12:08 BST, Thomas Gleixner <tglx@linutronix.de> w=
rote:
> > > On Sat, Oct 10 2020 at 12:58, David Woodhouse wrote:
> > > > On 10 October 2020 12:44:10 BST, Thomas Gleixner <tglx@linutronix.d=
e>
> > >=20
> > > wrote:
> > > > Yeah. There's some muttering to be done for HPET about whether it's
> > > > *its* MSI domain or whether it's the parent domain. But I'll have a
> > > > play. I think we'll be able to drop the whole
> > > > irq_remapping_get_irq_domain() thing.
> > >=20
> > > That would be really nice.
> >=20
> > I can make it work for HPET if I fix up the point at which the IRQ
> > remapping code registers a notifier on the platform bus. (At IRQ remap
> > setup time is too early; when it registers the PCI bus notifier is too
> > late.)
> >=20
> > IOAPIC is harder though as the platform bus doesn't even exist that
> > early. Maybe an early platform bus is possible but it would have to
> > turn out particularly simple to do, or I'd need to find another use
> > case too, to justify it. Will continue to play....
>=20
> You might want to look into using irq_find_matching_fwspec() instead for
> both HPET and IOAPIC. That needs a select() callback implemented in the
> remapping domains.

That works. Pushed (along with that trivial HPET MSI fixup) to=20
https://git.infradead.org/users/dwmw2/linux.git/shortlog/refs/heads/ext_des=
t_id

Briefly tested with I/OAPIC with and without Intel remapping in qemu,
not tested for HPET because I haven't worked out how to get qemu to do
HPET-MSI yet.

David Woodhouse (8):
      genirq/irqdomain: Implement get_name() method on irqchip fwnodes
      x86/apic: Add select() method on vector irqdomain
      iommu/amd: Implement select() method on remapping irqdomain
      iommu/vt-d: Implement select() method on remapping irqdomain
      iommu/hyper-v: Implement select() method on remapping irqdomain
      x86/hpet: Use irq_find_matching_fwspec() to find remapping irqdomain
      x86/ioapic: Use irq_find_matching_fwspec() to find remapping irqdomai=
n
      x86: Kill all traces of irq_remapping_get_irq_domain()

 arch/x86/include/asm/hw_irq.h        |  2 --
 arch/x86/include/asm/irq_remapping.h |  9 ------
 arch/x86/include/asm/irqdomain.h     |  3 ++
 arch/x86/kernel/apic/io_apic.c       | 21 ++++++--------
 arch/x86/kernel/apic/vector.c        | 52 ++++++++++++++++++++++++++++++++=
+++
 arch/x86/kernel/hpet.c               | 23 +++++++++-------
 drivers/iommu/amd/iommu.c            | 53 +++++++++++++-------------------=
----
 drivers/iommu/hyperv-iommu.c         | 18 ++++++------
 drivers/iommu/intel/irq_remapping.c  | 30 +++++++++-----------
 drivers/iommu/irq_remapping.c        | 14 ----------
 drivers/iommu/irq_remapping.h        |  3 --
 kernel/irq/irqdomain.c               | 11 +++++++-
 12 files changed, 128 insertions(+), 111 deletions(-)

diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index aabd8f1b6bb0..aef795f17478 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -40,8 +40,6 @@ enum irq_alloc_type {
 	X86_IRQ_ALLOC_TYPE_PCI_MSIX,
 	X86_IRQ_ALLOC_TYPE_DMAR,
 	X86_IRQ_ALLOC_TYPE_UV,
-	X86_IRQ_ALLOC_TYPE_IOAPIC_GET_PARENT,
-	X86_IRQ_ALLOC_TYPE_HPET_GET_PARENT,
 };
=20
 struct ioapic_alloc_info {
diff --git a/arch/x86/include/asm/irq_remapping.h b/arch/x86/include/asm/ir=
q_remapping.h
index af4a151d70b3..7cc49432187f 100644
--- a/arch/x86/include/asm/irq_remapping.h
+++ b/arch/x86/include/asm/irq_remapping.h
@@ -44,9 +44,6 @@ extern int irq_remapping_reenable(int);
 extern int irq_remap_enable_fault_handling(void);
 extern void panic_if_irq_remap(const char *msg);
=20
-extern struct irq_domain *
-irq_remapping_get_irq_domain(struct irq_alloc_info *info);
-
 /* Create PCI MSI/MSIx irqdomain, use @parent as the parent irqdomain. */
 extern struct irq_domain *
 arch_create_remap_msi_irq_domain(struct irq_domain *par, const char *n, in=
t id);
@@ -71,11 +68,5 @@ static inline void panic_if_irq_remap(const char *msg)
 {
 }
=20
-static inline struct irq_domain *
-irq_remapping_get_irq_domain(struct irq_alloc_info *info)
-{
-	return NULL;
-}
-
 #endif /* CONFIG_IRQ_REMAP */
 #endif /* __X86_IRQ_REMAPPING_H */
diff --git a/arch/x86/include/asm/irqdomain.h b/arch/x86/include/asm/irqdom=
ain.h
index cd684d45cb5f..2fc85f523ace 100644
--- a/arch/x86/include/asm/irqdomain.h
+++ b/arch/x86/include/asm/irqdomain.h
@@ -12,6 +12,9 @@ enum {
 	X86_IRQ_ALLOC_LEGACY				=3D 0x2,
 };
=20
+int x86_fwspec_is_ioapic(struct irq_fwspec *fwspec);
+int x86_fwspec_is_hpet(struct irq_fwspec *fwspec);
+
 extern struct irq_domain *x86_vector_domain;
=20
 extern void init_irq_alloc_info(struct irq_alloc_info *info,
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.=
c
index ca2da19d5c55..f6a5b9f887aa 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2305,36 +2305,33 @@ static inline void __init check_timer(void)
=20
 static int mp_irqdomain_create(int ioapic)
 {
-	struct irq_alloc_info info;
 	struct irq_domain *parent;
 	int hwirqs =3D mp_ioapic_pin_count(ioapic);
 	struct ioapic *ip =3D &ioapics[ioapic];
 	struct ioapic_domain_cfg *cfg =3D &ip->irqdomain_cfg;
 	struct mp_ioapic_gsi *gsi_cfg =3D mp_ioapic_gsi_routing(ioapic);
 	struct fwnode_handle *fn;
-	char *name =3D "IO-APIC";
+	struct irq_fwspec fwspec;
=20
 	if (cfg->type =3D=3D IOAPIC_DOMAIN_INVALID)
 		return 0;
=20
-	init_irq_alloc_info(&info, NULL);
-	info.type =3D X86_IRQ_ALLOC_TYPE_IOAPIC_GET_PARENT;
-	info.devid =3D mpc_ioapic_id(ioapic);
-	parent =3D irq_remapping_get_irq_domain(&info);
-	if (!parent)
-		parent =3D x86_vector_domain;
-	else
-		name =3D "IO-APIC-IR";
-
 	/* Handle device tree enumerated APICs proper */
 	if (cfg->dev) {
 		fn =3D of_node_to_fwnode(cfg->dev);
 	} else {
-		fn =3D irq_domain_alloc_named_id_fwnode(name, ioapic);
+		fn =3D irq_domain_alloc_named_id_fwnode("IO-APIC", ioapic);
 		if (!fn)
 			return -ENOMEM;
 	}
=20
+	fwspec.fwnode =3D fn;
+	fwspec.param_count =3D 1;
+	fwspec.param[0] =3D ioapic;
+	parent =3D irq_find_matching_fwspec(&fwspec, DOMAIN_BUS_ANY);
+	if (!parent)
+		return -ENODEV;
+
 	ip->irqdomain =3D irq_domain_create_linear(fn, hwirqs, cfg->ops,
 						 (void *)(long)ioapic);
=20
diff --git a/arch/x86/kernel/apic/vector.c b/arch/x86/kernel/apic/vector.c
index bb2e2a2488a5..3f0485c12b13 100644
--- a/arch/x86/kernel/apic/vector.c
+++ b/arch/x86/kernel/apic/vector.c
@@ -636,7 +636,59 @@ static void x86_vector_debug_show(struct seq_file *m, =
struct irq_domain *d,
 }
 #endif
=20
+
+int x86_fwspec_is_ioapic(struct irq_fwspec *fwspec)
+{
+	if (fwspec->param_count !=3D 1)
+		return 0;
+
+	if (is_fwnode_irqchip(fwspec->fwnode)){
+		const char *fwname =3D fwnode_get_name(fwspec->fwnode);
+
+		if (!strncmp(fwname, "IO-APIC-", 8) &&
+		    simple_strtol(fwname+8, NULL, 10) =3D=3D fwspec->param[0])
+			return 1;
+#ifdef CONFIG_OF
+	} else if (to_of_node(fwspec->fwnode) &&
+		   of_device_is_compatible(to_of_node(fwspec->fwnode),
+					   "intel,ce4100-ioapic")) {
+		return 1;
+#endif
+	}
+	return 0;
+}
+
+int x86_fwspec_is_hpet(struct irq_fwspec *fwspec)
+{
+	if (fwspec->param_count !=3D 1)
+		return 0;
+
+	if (is_fwnode_irqchip(fwspec->fwnode)){
+		const char *fwname =3D fwnode_get_name(fwspec->fwnode);
+
+		if (!strncmp(fwname, "HPET-MSI-", 9) &&
+		    simple_strtol(fwname+9, NULL, 10) =3D=3D fwspec->param[0])
+			return 1;
+	}
+	return 0;
+}
+
+static int x86_vector_select(struct irq_domain *d, struct irq_fwspec *fwsp=
ec,
+			     enum irq_domain_bus_token bus_token)
+{
+	/*
+	 * HPET and I/OAPIC cannot be parented in the vector domain
+	 * if IRQ remapping is enabled. APIC IDs above 15 bits are
+	 * only permitted if IRQ remapping is enabled, so check that.
+	 */
+	if (apic->apic_id_valid(32768))
+		return 0;
+
+	return x86_fwspec_is_ioapic(fwspec) || x86_fwspec_is_hpet(fwspec);
+}
+
 static const struct irq_domain_ops x86_vector_domain_ops =3D {
+	.select		=3D x86_vector_select,
 	.alloc		=3D x86_vector_alloc_irqs,
 	.free		=3D x86_vector_free_irqs,
 	.activate	=3D x86_vector_activate,
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 3b8b12769f3b..fb7736ca7b5b 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -543,8 +543,8 @@ static struct irq_domain *hpet_create_irq_domain(int hp=
et_id)
 {
 	struct msi_domain_info *domain_info;
 	struct irq_domain *parent, *d;
-	struct irq_alloc_info info;
 	struct fwnode_handle *fn;
+	struct irq_fwspec fwspec;
=20
 	if (x86_vector_domain =3D=3D NULL)
 		return NULL;
@@ -556,15 +556,6 @@ static struct irq_domain *hpet_create_irq_domain(int h=
pet_id)
 	*domain_info =3D hpet_msi_domain_info;
 	domain_info->data =3D (void *)(long)hpet_id;
=20
-	init_irq_alloc_info(&info, NULL);
-	info.type =3D X86_IRQ_ALLOC_TYPE_HPET_GET_PARENT;
-	info.devid =3D hpet_id;
-	parent =3D irq_remapping_get_irq_domain(&info);
-	if (parent =3D=3D NULL)
-		parent =3D x86_vector_domain;
-	else
-		hpet_msi_controller.name =3D "IR-HPET-MSI";
-
 	fn =3D irq_domain_alloc_named_id_fwnode(hpet_msi_controller.name,
 					      hpet_id);
 	if (!fn) {
@@ -572,6 +563,18 @@ static struct irq_domain *hpet_create_irq_domain(int h=
pet_id)
 		return NULL;
 	}
=20
+	fwspec.fwnode =3D fn;
+	fwspec.param_count =3D 1;
+	fwspec.param[0] =3D hpet_id;
+	parent =3D irq_find_matching_fwspec(&fwspec, DOMAIN_BUS_ANY);
+	if (!parent) {
+		irq_domain_free_fwnode(fn);
+		kfree(domain_info);
+		return NULL;
+	}
+	if (parent !=3D x86_vector_domain)
+		hpet_msi_controller.name =3D "IR-HPET-MSI";
+
 	d =3D msi_create_irq_domain(fn, domain_info, parent);
 	if (!d) {
 		irq_domain_free_fwnode(fn);
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 13d0a8f42d56..16adbf9d8fbb 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -3536,10 +3536,8 @@ static int get_devid(struct irq_alloc_info *info)
 {
 	switch (info->type) {
 	case X86_IRQ_ALLOC_TYPE_IOAPIC:
-	case X86_IRQ_ALLOC_TYPE_IOAPIC_GET_PARENT:
 		return get_ioapic_devid(info->devid);
 	case X86_IRQ_ALLOC_TYPE_HPET:
-	case X86_IRQ_ALLOC_TYPE_HPET_GET_PARENT:
 		return get_hpet_devid(info->devid);
 	case X86_IRQ_ALLOC_TYPE_PCI_MSI:
 	case X86_IRQ_ALLOC_TYPE_PCI_MSIX:
@@ -3550,46 +3548,32 @@ static int get_devid(struct irq_alloc_info *info)
 	}
 }
=20
-static struct irq_domain *get_irq_domain_for_devid(struct irq_alloc_info *=
info,
-						   int devid)
-{
-	struct amd_iommu *iommu =3D amd_iommu_rlookup_table[devid];
-
-	if (!iommu)
-		return NULL;
-
-	switch (info->type) {
-	case X86_IRQ_ALLOC_TYPE_IOAPIC_GET_PARENT:
-	case X86_IRQ_ALLOC_TYPE_HPET_GET_PARENT:
-		return iommu->ir_domain;
-	default:
-		WARN_ON_ONCE(1);
-		return NULL;
-	}
-}
-
-static struct irq_domain *get_irq_domain(struct irq_alloc_info *info)
-{
-	int devid;
-
-	if (!info)
-		return NULL;
-
-	devid =3D get_devid(info);
-	if (devid < 0)
-		return NULL;
-	return get_irq_domain_for_devid(info, devid);
-}
-
 struct irq_remap_ops amd_iommu_irq_ops =3D {
 	.prepare		=3D amd_iommu_prepare,
 	.enable			=3D amd_iommu_enable,
 	.disable		=3D amd_iommu_disable,
 	.reenable		=3D amd_iommu_reenable,
 	.enable_faulting	=3D amd_iommu_enable_faulting,
-	.get_irq_domain		=3D get_irq_domain,
 };
=20
+static int irq_remapping_select(struct irq_domain *d, struct irq_fwspec *f=
wspec,
+				enum irq_domain_bus_token bus_token)
+{
+	struct amd_iommu *iommu;
+	int devid =3D -1;
+
+	if (x86_fwspec_is_ioapic(fwspec))
+		devid =3D get_ioapic_devid(fwspec->param[0]);
+	else if (x86_fwspec_is_ioapic(fwspec))
+		devid =3D get_hpet_devid(fwspec->param[0]);
+
+	if (devid < 0)
+		return 0;
+
+	iommu =3D amd_iommu_rlookup_table[devid];
+	return iommu && iommu->ir_domain =3D=3D d;
+}
+
 static void irq_remapping_prepare_irte(struct amd_ir_data *data,
 				       struct irq_cfg *irq_cfg,
 				       struct irq_alloc_info *info,
@@ -3813,6 +3797,7 @@ static void irq_remapping_deactivate(struct irq_domai=
n *domain,
 }
=20
 static const struct irq_domain_ops amd_ir_domain_ops =3D {
+	.select =3D irq_remapping_select,
 	.alloc =3D irq_remapping_alloc,
 	.free =3D irq_remapping_free,
 	.activate =3D irq_remapping_activate,
diff --git a/drivers/iommu/hyperv-iommu.c b/drivers/iommu/hyperv-iommu.c
index 37dd485a5640..e7ed2bb83358 100644
--- a/drivers/iommu/hyperv-iommu.c
+++ b/drivers/iommu/hyperv-iommu.c
@@ -61,6 +61,14 @@ static struct irq_chip hyperv_ir_chip =3D {
 	.irq_set_affinity	=3D hyperv_ir_set_affinity,
 };
=20
+static int hyperv_irq_remapping_select(struct irq_domain *d,
+				       struct irq_fwspec *fwspec,
+				       enum irq_domain_bus_token bus_token)
+{
+	/* Claim only the first (and only) I/OAPIC */
+	return x86_fwspec_is_ioapic(fwspec) && fwspec->param[0] =3D=3D 0;
+}
+
 static int hyperv_irq_remapping_alloc(struct irq_domain *domain,
 				     unsigned int virq, unsigned int nr_irqs,
 				     void *arg)
@@ -102,6 +110,7 @@ static void hyperv_irq_remapping_free(struct irq_domain=
 *domain,
 }
=20
 static const struct irq_domain_ops hyperv_ir_domain_ops =3D {
+	.select =3D hyperv_irq_remapping_select,
 	.alloc =3D hyperv_irq_remapping_alloc,
 	.free =3D hyperv_irq_remapping_free,
 };
@@ -151,18 +160,9 @@ static int __init hyperv_enable_irq_remapping(void)
 	return IRQ_REMAP_X2APIC_MODE;
 }
=20
-static struct irq_domain *hyperv_get_irq_domain(struct irq_alloc_info *inf=
o)
-{
-	if (info->type =3D=3D X86_IRQ_ALLOC_TYPE_IOAPIC_GET_PARENT)
-		return ioapic_ir_domain;
-	else
-		return NULL;
-}
-
 struct irq_remap_ops hyperv_irq_remap_ops =3D {
 	.prepare		=3D hyperv_prepare_irq_remapping,
 	.enable			=3D hyperv_enable_irq_remapping,
-	.get_irq_domain		=3D hyperv_get_irq_domain,
 };
=20
 #endif
diff --git a/drivers/iommu/intel/irq_remapping.c b/drivers/iommu/intel/irq_=
remapping.c
index 511dfb4884bc..ccf61cd18f69 100644
--- a/drivers/iommu/intel/irq_remapping.c
+++ b/drivers/iommu/intel/irq_remapping.c
@@ -1128,29 +1128,12 @@ static void prepare_irte(struct irte *irte, int vec=
tor, unsigned int dest)
 	irte->redir_hint =3D 1;
 }
=20
-static struct irq_domain *intel_get_irq_domain(struct irq_alloc_info *info=
)
-{
-	if (!info)
-		return NULL;
-
-	switch (info->type) {
-	case X86_IRQ_ALLOC_TYPE_IOAPIC_GET_PARENT:
-		return map_ioapic_to_ir(info->devid);
-	case X86_IRQ_ALLOC_TYPE_HPET_GET_PARENT:
-		return map_hpet_to_ir(info->devid);
-	default:
-		WARN_ON_ONCE(1);
-		return NULL;
-	}
-}
-
 struct irq_remap_ops intel_irq_remap_ops =3D {
 	.prepare		=3D intel_prepare_irq_remapping,
 	.enable			=3D intel_enable_irq_remapping,
 	.disable		=3D disable_irq_remapping,
 	.reenable		=3D reenable_irq_remapping,
 	.enable_faulting	=3D enable_drhd_fault_handling,
-	.get_irq_domain		=3D intel_get_irq_domain,
 };
=20
 static void intel_ir_reconfigure_irte(struct irq_data *irqd, bool force)
@@ -1435,7 +1418,20 @@ static void intel_irq_remapping_deactivate(struct ir=
q_domain *domain,
 	modify_irte(&data->irq_2_iommu, &entry);
 }
=20
+static int intel_irq_remapping_select(struct irq_domain *d,
+				      struct irq_fwspec *fwspec,
+				      enum irq_domain_bus_token bus_token)
+{
+	if (x86_fwspec_is_ioapic(fwspec))
+		return d =3D=3D map_ioapic_to_ir(fwspec->param[0]);
+	else if (x86_fwspec_is_hpet(fwspec))
+		return d =3D=3D map_hpet_to_ir(fwspec->param[0]);
+
+	return 0;
+}
+
 static const struct irq_domain_ops intel_ir_domain_ops =3D {
+	.select =3D intel_irq_remapping_select,
 	.alloc =3D intel_irq_remapping_alloc,
 	.free =3D intel_irq_remapping_free,
 	.activate =3D intel_irq_remapping_activate,
diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index 2d84b1ed205e..83314b9d8f38 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -158,17 +158,3 @@ void panic_if_irq_remap(const char *msg)
 	if (irq_remapping_enabled)
 		panic(msg);
 }
-
-/**
- * irq_remapping_get_irq_domain - Get the irqdomain serving the request @i=
nfo
- * @info: interrupt allocation information, used to identify the IOMMU dev=
ice
- *
- * Returns pointer to IRQ domain, or NULL on failure.
- */
-struct irq_domain *irq_remapping_get_irq_domain(struct irq_alloc_info *inf=
o)
-{
-	if (!remap_ops || !remap_ops->get_irq_domain)
-		return NULL;
-
-	return remap_ops->get_irq_domain(info);
-}
diff --git a/drivers/iommu/irq_remapping.h b/drivers/iommu/irq_remapping.h
index 1661b3d75920..8c89cb947cdb 100644
--- a/drivers/iommu/irq_remapping.h
+++ b/drivers/iommu/irq_remapping.h
@@ -42,9 +42,6 @@ struct irq_remap_ops {
=20
 	/* Enable fault handling */
 	int  (*enable_faulting)(void);
-
-	/* Get the irqdomain associated to IOMMU device */
-	struct irq_domain *(*get_irq_domain)(struct irq_alloc_info *);
 };
=20
 extern struct irq_remap_ops intel_irq_remap_ops;
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 76cd7ebd1178..6440f97c412e 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -42,7 +42,16 @@ static inline void debugfs_add_domain_dir(struct irq_dom=
ain *d) { }
 static inline void debugfs_remove_domain_dir(struct irq_domain *d) { }
 #endif
=20
-const struct fwnode_operations irqchip_fwnode_ops;
+static const char *irqchip_fwnode_get_name(const struct fwnode_handle *fwn=
ode)
+{
+	struct irqchip_fwid *fwid =3D container_of(fwnode, struct irqchip_fwid, f=
wnode);
+
+	return fwid->name;
+}
+
+const struct fwnode_operations irqchip_fwnode_ops =3D {
+	.get_name =3D irqchip_fwnode_get_name,
+};
 EXPORT_SYMBOL_GPL(irqchip_fwnode_ops);
=20
 /**

--=-FZJqNo/G0THb9yJ11szo
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
MDEyMTYwNjQxWjAvBgkqhkiG9w0BCQQxIgQgvAbA5jpzNcLILn5G0xS3QeJ8IWpI6ThQARbEJQ9c
Emwwgb4GCSsGAQQBgjcQBDGBsDCBrTCBlzELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIg
TWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQx
PTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1h
aWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMIHABgsqhkiG9w0BCRACCzGBsKCBrTCBlzELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgG
A1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhl
bnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMA0GCSqGSIb3
DQEBAQUABIIBAHV7RM6z7biE+C6vI/iIWnVtGuv+HNtl1S0v6+sk6PtMjK1dOMfGikBy3EACrELe
PHTqWFo8y8aUW8Tw0+/lgX6M7c04uftWQGWY5Jkn+mEto8f1qJ8o0XeUVUDA9MGVHhBh40Z5v1Se
8ZKH+xv44/zd6aLSUY7qXuE7MzjMtJ2zbbqfq+UIuWhMW5NdJGKHfp8cfasduAqioScHnlQmIn8Q
5p3A5+LwjtB/a4UJPsSWre6DcKoTBaZqtoAg8t9nwBvA+vzpBtYYvxlqf3e3gMaG6Zq82YV2nVDk
XlqF+sOjAxFVfQXLbQMjEjRT5a21s1kUwi6ChDjZPG3SmltxdBkAAAAAAAA=


--=-FZJqNo/G0THb9yJ11szo--

