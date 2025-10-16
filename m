Return-Path: <kvm+bounces-60211-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CA67BE5085
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 20:20:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F0A6C3BD398
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 18:20:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A5B022A1E1;
	Thu, 16 Oct 2025 18:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b="HNDb4cyW"
X-Original-To: kvm@vger.kernel.org
Received: from outbound.qs.icloud.com (p-east3-cluster5-host3-snip4-10.eps.apple.com [57.103.86.161])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4CBD221D96
	for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 18:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.86.161
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760638813; cv=none; b=NLcA668pEViLTcscs4Y/fHDi1IKEAPvpuvQQR9bRmu21u6iRrM6w0bFjNN7jXb4crVnWbkgvKAN+rtdtaQpLkY7eaNsf/CIRbvTlNLGJMl6REALwBm35yeDu+xZObS8b/n8gDzMOo2Uep98GGLYor/iRiY15VSvjmZEQwwojMfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760638813; c=relaxed/simple;
	bh=OJwfpNen29jMpz/j2ctA23V2Vnnfriq9JHBQzge+jTI=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=H7b3KWNrHB4D9cwfIgDFOXoT3rvfkg7S+US99Lj8hR+Mw7GZw2gq/Ri+Oa/esStPS23WioX2PIMU+1H0Tor3otZ/MS1iJ1R8AyFjp42p+XUcRRo6vPmdXHJP6BwUxgZ1xqW9BCR7EEEq7uc//RmDm5FbZQFOumEbCO+rYJP5rM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr; spf=pass smtp.mailfrom=unpredictable.fr; dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b=HNDb4cyW; arc=none smtp.client-ip=57.103.86.161
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=unpredictable.fr
Received: from outbound.qs.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-2d-20-percent-1 (Postfix) with ESMTPS id E48FA1803F0E;
	Thu, 16 Oct 2025 18:20:03 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unpredictable.fr; s=sig1; bh=0sliVfqQ1qYVTL2tWh98QP6GLMgrCSXdnHbu898n1/Y=; h=Content-Type:Mime-Version:Subject:From:Date:Message-Id:To:x-icloud-hme; b=HNDb4cyWXm5kBUlKW3rhvEe05l3L3YNzaukdaCD4MWH839jxzcZICMc329ui1AtetalA5ZSowv4aeQHNOKgHFtr7MYz5WHAVuafRE7i63+5JXGwND8O4N5TWDKam+UwSgLzq3oqIDkyrqpWx8FWKl0y0ig+zdvezdLcpNumZ9BeN62QQHJ1EivHz7AEX7jXFp5AFQjkFa+buKRyDj3NlAhjhbaX+oqwxhlHDY5qCnRDBVhJH6Fy60Z2484fkhsEBdwErPvczBY+n93wBDn4khx8Pmm7sBuiy9puPIy8zp5T/PoZXb4YM15ydyjJcJOVPt9tmqUZT0wtUd5ZtqCr4/Q==
mail-alias-created-date: 1752046281608
Received: from smtpclient.apple (unknown [17.57.155.37])
	by p00-icloudmta-asmtp-us-east-2d-20-percent-1 (Postfix) with ESMTPSA id 8DEFC180016E;
	Thu, 16 Oct 2025 18:20:00 +0000 (UTC)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.100.1.1.5\))
Subject: Re: [PATCH v7 15/24] hw/arm: virt: cleanly fail on attempt to use the
 platform vGIC together with ITS
From: Mohamed Mediouni <mohamed@unpredictable.fr>
In-Reply-To: <20251016165520.62532-16-mohamed@unpredictable.fr>
Date: Thu, 16 Oct 2025 20:19:48 +0200
Cc: Alexander Graf <agraf@csgraf.de>,
 Richard Henderson <richard.henderson@linaro.org>,
 Cameron Esfahani <dirty@apple.com>,
 Mads Ynddal <mads@ynddal.dk>,
 qemu-arm@nongnu.org,
 =?utf-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Ani Sinha <anisinha@redhat.com>,
 Phil Dennis-Jordan <phil@philjordan.eu>,
 Eduardo Habkost <eduardo@habkost.net>,
 Sunil Muthuswamy <sunilmut@microsoft.com>,
 "Michael S. Tsirkin" <mst@redhat.com>,
 Igor Mammedov <imammedo@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Yanan Wang <wangyanan55@huawei.com>,
 =?utf-8?B?IkRhbmllbCBQLiBCZXJyYW5nw6ki?= <berrange@redhat.com>,
 Shannon Zhao <shannon.zhaosl@gmail.com>,
 kvm@vger.kernel.org,
 Peter Maydell <peter.maydell@linaro.org>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 =?utf-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 Pedro Barbuda <pbarbuda@microsoft.com>,
 Zhao Liu <zhao1.liu@intel.com>,
 Roman Bolshakov <rbolshakov@ddn.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <25E6C302-43A7-4D52-BFBA-0712085DF63F@unpredictable.fr>
References: <20251016165520.62532-1-mohamed@unpredictable.fr>
 <20251016165520.62532-16-mohamed@unpredictable.fr>
To: qemu-devel@nongnu.org
X-Mailer: Apple Mail (2.3864.100.1.1.5)
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE2MDEzNCBTYWx0ZWRfXwMpWzhOUN9+2
 8zYHBRddSxbJiif72Uh9OsEaFF+bjuWHTDaqv09cSJxXLV1UE04IdaUspkkSCAo+SydVCthYVHw
 a+QG1mCbEmz35LYtfVXDvIhwjU/mqzZVWQhxjoBHQ2PW13g3i5+Scor/hh+M9he7DF2O8QXwLBl
 PCEeFx3ky8ar9Qko0W8NGhEtRbT30qqaHXv8aLx/num9HFWguxNHPUy1NmiaMn1uGL0DNFRfkRP
 ZM5TjXMn0rMP5dTuAhRKewGLElETD6MYI1y5+c/hG3DPjsCk3ZPrIePe6rApAFkbbEQWX9k0w=
X-Proofpoint-ORIG-GUID: uXx7AHwdeKCCFEaE-XuFHl4J98R3LI6F
X-Proofpoint-GUID: uXx7AHwdeKCCFEaE-XuFHl4J98R3LI6F
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-16_03,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 suspectscore=0 bulkscore=0 mlxscore=0 clxscore=1030 phishscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.22.0-2506270000 definitions=main-2510160134
X-JNJ: AAAAAAAB6tYxoF59Lulaw0xGzfxww/gvuSurVQgLU2lSLYUmDhwoxqH7lPSmcYsiq7ZJSQwau81JjlEGJM4ADDErGtwiNAuQBnzuzWBLJSn9zDiNHZoefnK0nups3pybyD0mrR4ZNQgCRLiVMutY2pSEnYdL/6aycPBvLbBfFATwaEmzORn9iE9gACpeGYHt7ra4znVdEaTQIRRL7gEqpV1J2owOlC9NeYHuX1/eWmIkiI5BYLgkMJLakCMtwmavHkyb9BnAnb4k4USg4L+FDTF44H8o+W2/GWGR3yXQb2WpS5Z0zXn8flkNWRlNI0ZX04yCYh5y//uJUQE13dtiBa1A3ONhYXcmyGWJQC5GhwUvGZWrVZYxKDEKy1+jwUnZU3zb0NObqYy9wdbQKBZelh4IIUvN8XHYkW5nUuC9HvhkaiLpL1iqdjeYoPcK10JDuEXnxvldH52lT8WDIs5uWiV9ZodVhcuTa+64Pn2hk96h63x7wL1+v/6McoOjvuRI9dNCH/jOjB9UVrhzhkxJJwZ4tZw5eI410etC8H0rpazY3kUe/LMRgPuGNO+/IqgoBEA3TSIioBCPQYLlsy9NRGubEGp3qkJzoDSEQMIRGrWtG+G1J38+87lnZHTq6ZEwzKt9e5bauhAOo9tPh+QkMVk9panRiiieu+rRgwA5RWo7037eK3aJ3q9qL56tKLgOTX5l35WFXMGfJY58flFri9BzbJzpNEY8VmcTGskCfbbX+k2HHAOTKGnXBm6QV4n7+CtEoAJ3b1nUfh3q07dBFim47/Xy4mBlLO6aahIn+pC+LzOMx6sR7PcaTEDcqxOYUoFiN0znMYMApDXhNAD7bk7QDm2AD/g7Hdz4ERukFrwnjR3IcxCVokN5zZO4s7fBwIuRH2UAbRPbVwvOtbQI7atDkh333i241NZSn+ABPg==

Note for this specific one (already posted on IRC, but worth keeping in =
mind for a merge), mail server is misbehaving=E2=80=A6 (so v8 has been =
posted partially. And this is the change there)

It has a bug, with the changed commit being at =
https://github.com/mediouni-m/qemu/commit/863eb69916be4a43ddde62276bb643ca=
f46ef236

The delta between the two:

diff --git a/hw/arm/virt-acpi-build.c b/hw/arm/virt-acpi-build.c
index c716130206..8e730731ca 100644
--- a/hw/arm/virt-acpi-build.c
+++ b/hw/arm/virt-acpi-build.c
@@ -961,7 +961,8 @@ build_madt(GArray *table_data, BIOSLinker *linker, =
VirtMachineState *vms)
        }
    }

-    if (virt_is_its_enabled(vms) && !vms->no_gicv3_with_gicv2m) {
+    if (!(vms->gic_version !=3D VIRT_GIC_VERSION_2 && =
virt_is_its_enabled(vms))
+     && !vms->no_gicv3_with_gicv2m) {
        const uint16_t spi_base =3D vms->irqmap[VIRT_GIC_V2M] + =
ARM_SPI_BASE;

        /* 5.2.12.16 GIC MSI Frame Structure */

diff --git a/hw/arm/virt.c b/hw/arm/virt.c
index 1904765db3..b5bed029b9 100644
--- a/hw/arm/virt.c
+++ b/hw/arm/virt.c
@@ -2717,10 +2717,6 @@ static void virt_set_highmem_mmio_size(Object =
*obj, Visitor *v,

bool virt_is_its_enabled(VirtMachineState *vms)
{
-    if (vms->gic_version =3D=3D VIRT_GIC_VERSION_2) {
-        return false;
-    }
-
    if (vms->its =3D=3D ON_OFF_AUTO_OFF) {
        return false;
    }



> On 16. Oct 2025, at 18:55, Mohamed Mediouni <mohamed@unpredictable.fr> =
wrote:
>=20
> Switch its to a tristate.
>=20
> Windows Hypervisor Platform's vGIC doesn't support ITS.
> Deal with this by reporting to the user and exiting.
>=20
> Regular configuration: GICv3 + ITS
> New default configuration with WHPX: GICv3 with GICv2m
> And its=3Doff explicitly for the newest machine version: GICv3 + =
GICv2m
>=20
> Signed-off-by: Mohamed Mediouni <mohamed@unpredictable.fr>
> ---
> hw/arm/virt-acpi-build.c | 14 +++++------
> hw/arm/virt.c            | 50 ++++++++++++++++++++++++++++++++--------
> include/hw/arm/virt.h    |  4 +++-
> 3 files changed, 50 insertions(+), 18 deletions(-)
>=20
> diff --git a/hw/arm/virt-acpi-build.c b/hw/arm/virt-acpi-build.c
> index 0a6ec74aa0..c716130206 100644
> --- a/hw/arm/virt-acpi-build.c
> +++ b/hw/arm/virt-acpi-build.c
> @@ -472,7 +472,7 @@ build_iort(GArray *table_data, BIOSLinker *linker, =
VirtMachineState *vms)
>        nb_nodes =3D num_smmus + 1; /* RC and SMMUv3 */
>        rc_mapping_count =3D rc_smmu_idmaps_len;
>=20
> -        if (vms->its) {
> +        if (virt_is_its_enabled(vms)) {
>            /*
>             * Knowing the ID ranges from the RC to the SMMU, it's =
possible to
>             * determine the ID ranges from RC that go directly to ITS.
> @@ -483,7 +483,7 @@ build_iort(GArray *table_data, BIOSLinker *linker, =
VirtMachineState *vms)
>            rc_mapping_count +=3D rc_its_idmaps->len;
>        }
>    } else {
> -        if (vms->its) {
> +        if (virt_is_its_enabled(vms)) {
>            nb_nodes =3D 2; /* RC and ITS */
>            rc_mapping_count =3D 1; /* Direct map to ITS */
>        } else {
> @@ -498,7 +498,7 @@ build_iort(GArray *table_data, BIOSLinker *linker, =
VirtMachineState *vms)
>    build_append_int_noprefix(table_data, IORT_NODE_OFFSET, 4);
>    build_append_int_noprefix(table_data, 0, 4); /* Reserved */
>=20
> -    if (vms->its) {
> +    if (virt_is_its_enabled(vms)) {
>        /* Table 12 ITS Group Format */
>        build_append_int_noprefix(table_data, 0 /* ITS Group */, 1); /* =
Type */
>        node_size =3D  20 /* fixed header size */ + 4 /* 1 GIC ITS =
Identifier */;
> @@ -517,7 +517,7 @@ build_iort(GArray *table_data, BIOSLinker *linker, =
VirtMachineState *vms)
>        int smmu_mapping_count, offset_to_id_array;
>        int irq =3D sdev->irq;
>=20
> -        if (vms->its) {
> +        if (virt_is_its_enabled(vms)) {
>            smmu_mapping_count =3D 1; /* ITS Group node */
>            offset_to_id_array =3D SMMU_V3_ENTRY_SIZE; /* Just after =
the header */
>        } else {
> @@ -610,7 +610,7 @@ build_iort(GArray *table_data, BIOSLinker *linker, =
VirtMachineState *vms)
>            }
>        }
>=20
> -        if (vms->its) {
> +        if (virt_is_its_enabled(vms)) {
>            /*
>             * Map bypassed (don't go through the SMMU) RIDs (input) to
>             * ITS Group node directly: RC -> ITS.
> @@ -945,7 +945,7 @@ build_madt(GArray *table_data, BIOSLinker *linker, =
VirtMachineState *vms)
>                                          =
memmap[VIRT_HIGH_GIC_REDIST2].size);
>        }
>=20
> -        if (vms->its) {
> +        if (virt_is_its_enabled(vms)) {
>            /*
>             * ACPI spec, Revision 6.0 Errata A
>             * (original 6.0 definition has invalid Length)
> @@ -961,7 +961,7 @@ build_madt(GArray *table_data, BIOSLinker *linker, =
VirtMachineState *vms)
>        }
>    }
>=20
> -    if (!(vms->gic_version !=3D VIRT_GIC_VERSION_2 && vms->its) && =
!vms->no_gicv3_with_gicv2m) {
> +    if (virt_is_its_enabled(vms) && !vms->no_gicv3_with_gicv2m) {
>        const uint16_t spi_base =3D vms->irqmap[VIRT_GIC_V2M] + =
ARM_SPI_BASE;
>=20
>        /* 5.2.12.16 GIC MSI Frame Structure */
> diff --git a/hw/arm/virt.c b/hw/arm/virt.c
> index 9121eb37eb..1bebbc265d 100644
> --- a/hw/arm/virt.c
> +++ b/hw/arm/virt.c
> @@ -735,7 +735,7 @@ static void create_its(VirtMachineState *vms)
> {
>    DeviceState *dev;
>=20
> -    assert(vms->its);
> +    assert(virt_is_its_enabled(vms));
>    if (!kvm_irqchip_in_kernel() && !vms->tcg_its) {
>        /*
>         * Do nothing if ITS is neither supported by the host nor =
emulated by
> @@ -744,6 +744,15 @@ static void create_its(VirtMachineState *vms)
>        return;
>    }
>=20
> +    if (whpx_enabled() && vms->tcg_its) {
> +        /*
> +         * Signal to the user when ITS is neither supported by the =
host
> +         * nor emulated by the machine.
> +         */
> +        info_report("ITS not supported on WHPX.");
> +        exit(1);
> +    }
> +
>    dev =3D qdev_new(its_class_name());
>=20
>    object_property_set_link(OBJECT(dev), "parent-gicv3", =
OBJECT(vms->gic),
> @@ -955,7 +964,7 @@ static void create_gic(VirtMachineState *vms, =
MemoryRegion *mem)
>=20
>    fdt_add_gic_node(vms);
>=20
> -    if (vms->gic_version !=3D VIRT_GIC_VERSION_2 && vms->its) {
> +    if (vms->gic_version !=3D VIRT_GIC_VERSION_2 && =
virt_is_its_enabled(vms)) {
>        create_its(vms);
>    } else if (vms->gic_version !=3D VIRT_GIC_VERSION_2 && =
!vms->no_gicv3_with_gicv2m) {
>        create_v2m(vms);
> @@ -2705,18 +2714,38 @@ static void virt_set_highmem_mmio_size(Object =
*obj, Visitor *v,
>    extended_memmap[VIRT_HIGH_PCIE_MMIO].size =3D size;
> }
>=20
> -static bool virt_get_its(Object *obj, Error **errp)
> +bool virt_is_its_enabled(VirtMachineState *vms)
> +{
> +    if (vms->gic_version =3D=3D VIRT_GIC_VERSION_2) {
> +        return false;
> +    }
> +
> +    if (vms->its =3D=3D ON_OFF_AUTO_OFF) {
> +        return false;
> +    }
> +    if (vms->its =3D=3D ON_OFF_AUTO_AUTO) {
> +        if (whpx_enabled()) {
> +            return false;
> +        }
> +    }
> +    return true;
> +}
> +
> +static void virt_get_its(Object *obj, Visitor *v, const char *name,
> +                          void *opaque, Error **errp)
> {
>    VirtMachineState *vms =3D VIRT_MACHINE(obj);
> +    OnOffAuto its =3D vms->its;
>=20
> -    return vms->its;
> +    visit_type_OnOffAuto(v, name, &its, errp);
> }
>=20
> -static void virt_set_its(Object *obj, bool value, Error **errp)
> +static void virt_set_its(Object *obj, Visitor *v, const char *name,
> +                          void *opaque, Error **errp)
> {
>    VirtMachineState *vms =3D VIRT_MACHINE(obj);
>=20
> -    vms->its =3D value;
> +    visit_type_OnOffAuto(v, name, &vms->its, errp);
> }
>=20
> static bool virt_get_dtb_randomness(Object *obj, Error **errp)
> @@ -3426,8 +3455,9 @@ static void virt_machine_class_init(ObjectClass =
*oc, const void *data)
>                                          "guest CPU which implements =
the ARM "
>                                          "Memory Tagging Extension");
>=20
> -    object_class_property_add_bool(oc, "its", virt_get_its,
> -                                   virt_set_its);
> +    object_class_property_add(oc, "its", "OnOffAuto",
> +        virt_get_its, virt_set_its,
> +        NULL, NULL);
>    object_class_property_set_description(oc, "its",
>                                          "Set on/off to enable/disable =
"
>                                          "ITS instantiation");
> @@ -3487,8 +3517,8 @@ static void virt_instance_init(Object *obj)
>    vms->highmem_mmio =3D true;
>    vms->highmem_redists =3D true;
>=20
> -    /* Default allows ITS instantiation */
> -    vms->its =3D true;
> +    /* Default allows ITS instantiation if available */
> +    vms->its =3D ON_OFF_AUTO_AUTO;
>    /* Allow ITS emulation if the machine version supports it */
>    vms->tcg_its =3D !vmc->no_tcg_its;
>    vms->no_gicv3_with_gicv2m =3D false;
> diff --git a/include/hw/arm/virt.h b/include/hw/arm/virt.h
> index d31348dd61..997dd51678 100644
> --- a/include/hw/arm/virt.h
> +++ b/include/hw/arm/virt.h
> @@ -149,7 +149,7 @@ struct VirtMachineState {
>    bool highmem_ecam;
>    bool highmem_mmio;
>    bool highmem_redists;
> -    bool its;
> +    OnOffAuto its;
>    bool tcg_its;
>    bool virt;
>    bool ras;
> @@ -218,4 +218,6 @@ static inline int =
virt_gicv3_redist_region_count(VirtMachineState *vms)
>            vms->highmem_redists) ? 2 : 1;
> }
>=20
> +bool virt_is_its_enabled(VirtMachineState *vms);
> +
> #endif /* QEMU_ARM_VIRT_H */
> --=20
> 2.50.1 (Apple Git-155)
>=20


