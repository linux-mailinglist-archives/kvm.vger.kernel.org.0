Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C51442E08
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2019 19:56:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403853AbfFLRzh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jun 2019 13:55:37 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:40494 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388785AbfFLRxP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jun 2019 13:53:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:
        To:From:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=0KxoVoef7jUHxK7kVmlOGRwHRoucGKDZ/6xcLavKGUU=; b=p0e5zpuVpaZAfKUh5asBm5FNif
        NqVdOQAMZsVe3dtGzd7PBnGGiBY1Q0NKVj0YdaxY/VtRetoOlJM40XzkLoAI73TGJ1iCmDzwcWVMb
        ULrburRs2EeLKs9W22dn+yJgQhIrQHJkmFGymZVTNmpA3oh2HhRrswgJ9vM0QWae3hkv57kcwNvme
        QekunssBKgidpBB46JRej91FTy/EFsgJf4WK/OdWi0roSWsOfKMFscn7DMXMGay4cCpD6kXxiv6E5
        HVuKCrZiwg/zc/1RiTXl+mhTha1pXhI4x54VJtK+EPGwqGGGU592qfZP2vqAo+v3+mwSNApjFBkn3
        6p4MYyag==;
Received: from 201.86.169.251.dynamic.adsl.gvt.net.br ([201.86.169.251] helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hb7Qt-0002Dc-2w; Wed, 12 Jun 2019 17:53:12 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1hb7Qp-0001fl-Vq; Wed, 12 Jun 2019 14:53:07 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Harry Wei <harryxiyou@gmail.com>,
        Alex Shi <alex.shi@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        linux-efi@vger.kernel.org
Subject: [PATCH v4 02/28] docs: arm64: convert docs to ReST and rename to .rst
Date:   Wed, 12 Jun 2019 14:52:38 -0300
Message-Id: <8320e8e871660bf9fc426bc688f4808a1a7aa031.1560361364.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1560361364.git.mchehab+samsung@kernel.org>
References: <cover.1560361364.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The documentation is in a format that is very close to ReST format.

The conversion is actually:
  - add blank lines in order to identify paragraphs;
  - fixing tables markups;
  - adding some lists markups;
  - marking literal blocks;
  - adjust some title markups.

At its new index.rst, let's add a :orphan: while this is not linked to
the main index.rst file, in order to avoid build warnings.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 ...object_usage.txt => acpi_object_usage.rst} | 288 ++++++++++++------
 .../arm64/{arm-acpi.txt => arm-acpi.rst}      | 155 +++++-----
 .../arm64/{booting.txt => booting.rst}        |  91 ++++--
 ...egisters.txt => cpu-feature-registers.rst} | 204 +++++++------
 .../arm64/{elf_hwcaps.txt => elf_hwcaps.rst}  |  56 +---
 .../{hugetlbpage.txt => hugetlbpage.rst}      |   7 +-
 Documentation/arm64/index.rst                 |  28 ++
 ...structions.txt => legacy_instructions.rst} |  43 ++-
 Documentation/arm64/memory.rst                |  98 ++++++
 Documentation/arm64/memory.txt                |  97 ------
 ...ication.txt => pointer-authentication.rst} |   2 +
 ...{silicon-errata.txt => silicon-errata.rst} |  65 +++-
 Documentation/arm64/{sve.txt => sve.rst}      |  12 +-
 ...agged-pointers.txt => tagged-pointers.rst} |   6 +-
 .../translations/zh_CN/arm64/booting.txt      |   4 +-
 .../zh_CN/arm64/legacy_instructions.txt       |   4 +-
 .../translations/zh_CN/arm64/memory.txt       |   4 +-
 .../zh_CN/arm64/silicon-errata.txt            |   4 +-
 .../zh_CN/arm64/tagged-pointers.txt           |   4 +-
 Documentation/virtual/kvm/api.txt             |   2 +-
 arch/arm64/include/asm/efi.h                  |   2 +-
 arch/arm64/include/asm/image.h                |   2 +-
 arch/arm64/include/uapi/asm/sigcontext.h      |   2 +-
 arch/arm64/kernel/kexec_image.c               |   2 +-
 24 files changed, 703 insertions(+), 479 deletions(-)
 rename Documentation/arm64/{acpi_object_usage.txt => acpi_object_usage.rst} (84%)
 rename Documentation/arm64/{arm-acpi.txt => arm-acpi.rst} (86%)
 rename Documentation/arm64/{booting.txt => booting.rst} (86%)
 rename Documentation/arm64/{cpu-feature-registers.txt => cpu-feature-registers.rst} (65%)
 rename Documentation/arm64/{elf_hwcaps.txt => elf_hwcaps.rst} (92%)
 rename Documentation/arm64/{hugetlbpage.txt => hugetlbpage.rst} (86%)
 create mode 100644 Documentation/arm64/index.rst
 rename Documentation/arm64/{legacy_instructions.txt => legacy_instructions.rst} (73%)
 create mode 100644 Documentation/arm64/memory.rst
 delete mode 100644 Documentation/arm64/memory.txt
 rename Documentation/arm64/{pointer-authentication.txt => pointer-authentication.rst} (99%)
 rename Documentation/arm64/{silicon-errata.txt => silicon-errata.rst} (55%)
 rename Documentation/arm64/{sve.txt => sve.rst} (98%)
 rename Documentation/arm64/{tagged-pointers.txt => tagged-pointers.rst} (94%)

diff --git a/Documentation/arm64/acpi_object_usage.txt b/Documentation/arm64/acpi_object_usage.rst
similarity index 84%
rename from Documentation/arm64/acpi_object_usage.txt
rename to Documentation/arm64/acpi_object_usage.rst
index c77010c5c1f0..d51b69dc624d 100644
--- a/Documentation/arm64/acpi_object_usage.txt
+++ b/Documentation/arm64/acpi_object_usage.rst
@@ -1,5 +1,7 @@
+===========
 ACPI Tables
------------
+===========
+
 The expectations of individual ACPI tables are discussed in the list that
 follows.
 
@@ -11,54 +13,71 @@ outside of the UEFI Forum (see Section 5.2.6 of the specification).
 
 For ACPI on arm64, tables also fall into the following categories:
 
-       -- Required: DSDT, FADT, GTDT, MADT, MCFG, RSDP, SPCR, XSDT
+       -  Required: DSDT, FADT, GTDT, MADT, MCFG, RSDP, SPCR, XSDT
 
-       -- Recommended: BERT, EINJ, ERST, HEST, PCCT, SSDT
+       -  Recommended: BERT, EINJ, ERST, HEST, PCCT, SSDT
 
-       -- Optional: BGRT, CPEP, CSRT, DBG2, DRTM, ECDT, FACS, FPDT, IORT,
+       -  Optional: BGRT, CPEP, CSRT, DBG2, DRTM, ECDT, FACS, FPDT, IORT,
           MCHI, MPST, MSCT, NFIT, PMTT, RASF, SBST, SLIT, SPMI, SRAT, STAO,
 	  TCPA, TPM2, UEFI, XENV
 
-       -- Not supported: BOOT, DBGP, DMAR, ETDT, HPET, IBFT, IVRS, LPIT,
+       -  Not supported: BOOT, DBGP, DMAR, ETDT, HPET, IBFT, IVRS, LPIT,
           MSDM, OEMx, PSDT, RSDT, SLIC, WAET, WDAT, WDRT, WPBT
 
+====== ========================================================================
 Table  Usage for ARMv8 Linux
------  ----------------------------------------------------------------
+====== ========================================================================
 BERT   Section 18.3 (signature == "BERT")
-       == Boot Error Record Table ==
+
+       **Boot Error Record Table**
+
        Must be supplied if RAS support is provided by the platform.  It
        is recommended this table be supplied.
 
 BOOT   Signature Reserved (signature == "BOOT")
-       == simple BOOT flag table ==
+
+       **simple BOOT flag table**
+
        Microsoft only table, will not be supported.
 
 BGRT   Section 5.2.22 (signature == "BGRT")
-       == Boot Graphics Resource Table ==
+
+       **Boot Graphics Resource Table**
+
        Optional, not currently supported, with no real use-case for an
        ARM server.
 
 CPEP   Section 5.2.18 (signature == "CPEP")
-       == Corrected Platform Error Polling table ==
+
+       **Corrected Platform Error Polling table**
+
        Optional, not currently supported, and not recommended until such
        time as ARM-compatible hardware is available, and the specification
        suitably modified.
 
 CSRT   Signature Reserved (signature == "CSRT")
-       == Core System Resources Table ==
+
+       **Core System Resources Table**
+
        Optional, not currently supported.
 
 DBG2   Signature Reserved (signature == "DBG2")
-       == DeBuG port table 2 ==
+
+       **DeBuG port table 2**
+
        License has changed and should be usable.  Optional if used instead
        of earlycon=<device> on the command line.
 
 DBGP   Signature Reserved (signature == "DBGP")
-       == DeBuG Port table ==
+
+       **DeBuG Port table**
+
        Microsoft only table, will not be supported.
 
 DSDT   Section 5.2.11.1 (signature == "DSDT")
-       == Differentiated System Description Table ==
+
+       **Differentiated System Description Table**
+
        A DSDT is required; see also SSDT.
 
        ACPI tables contain only one DSDT but can contain one or more SSDTs,
@@ -66,22 +85,30 @@ DSDT   Section 5.2.11.1 (signature == "DSDT")
        but cannot modify or replace anything in the DSDT.
 
 DMAR   Signature Reserved (signature == "DMAR")
-       == DMA Remapping table ==
+
+       **DMA Remapping table**
+
        x86 only table, will not be supported.
 
 DRTM   Signature Reserved (signature == "DRTM")
-       == Dynamic Root of Trust for Measurement table ==
+
+       **Dynamic Root of Trust for Measurement table**
+
        Optional, not currently supported.
 
 ECDT   Section 5.2.16 (signature == "ECDT")
-       == Embedded Controller Description Table ==
+
+       **Embedded Controller Description Table**
+
        Optional, not currently supported, but could be used on ARM if and
        only if one uses the GPE_BIT field to represent an IRQ number, since
        there are no GPE blocks defined in hardware reduced mode.  This would
        need to be modified in the ACPI specification.
 
 EINJ   Section 18.6 (signature == "EINJ")
-       == Error Injection table ==
+
+       **Error Injection table**
+
        This table is very useful for testing platform response to error
        conditions; it allows one to inject an error into the system as
        if it had actually occurred.  However, this table should not be
@@ -89,27 +116,35 @@ EINJ   Section 18.6 (signature == "EINJ")
        and executed with the ACPICA tools only during testing.
 
 ERST   Section 18.5 (signature == "ERST")
-       == Error Record Serialization Table ==
+
+       **Error Record Serialization Table**
+
        On a platform supports RAS, this table must be supplied if it is not
        UEFI-based; if it is UEFI-based, this table may be supplied. When this
        table is not present, UEFI run time service will be utilized to save
        and retrieve hardware error information to and from a persistent store.
 
 ETDT   Signature Reserved (signature == "ETDT")
-       == Event Timer Description Table ==
+
+       **Event Timer Description Table**
+
        Obsolete table, will not be supported.
 
 FACS   Section 5.2.10 (signature == "FACS")
-       == Firmware ACPI Control Structure ==
+
+       **Firmware ACPI Control Structure**
+
        It is unlikely that this table will be terribly useful.  If it is
        provided, the Global Lock will NOT be used since it is not part of
        the hardware reduced profile, and only 64-bit address fields will
        be considered valid.
 
 FADT   Section 5.2.9 (signature == "FACP")
-       == Fixed ACPI Description Table ==
+
+       **Fixed ACPI Description Table**
        Required for arm64.
 
+
        The HW_REDUCED_ACPI flag must be set.  All of the fields that are
        to be ignored when HW_REDUCED_ACPI is set are expected to be set to
        zero.
@@ -118,22 +153,28 @@ FADT   Section 5.2.9 (signature == "FACP")
        used, not FIRMWARE_CTRL.
 
        If PSCI is used (as is recommended), make sure that ARM_BOOT_ARCH is
-       filled in properly -- that the PSCI_COMPLIANT flag is set and that
+       filled in properly - that the PSCI_COMPLIANT flag is set and that
        PSCI_USE_HVC is set or unset as needed (see table 5-37).
 
        For the DSDT that is also required, the X_DSDT field is to be used,
        not the DSDT field.
 
 FPDT   Section 5.2.23 (signature == "FPDT")
-       == Firmware Performance Data Table ==
+
+       **Firmware Performance Data Table**
+
        Optional, not currently supported.
 
 GTDT   Section 5.2.24 (signature == "GTDT")
-       == Generic Timer Description Table ==
+
+       **Generic Timer Description Table**
+
        Required for arm64.
 
 HEST   Section 18.3.2 (signature == "HEST")
-       == Hardware Error Source Table ==
+
+       **Hardware Error Source Table**
+
        ARM-specific error sources have been defined; please use those or the
        PCI types such as type 6 (AER Root Port), 7 (AER Endpoint), or 8 (AER
        Bridge), or use type 9 (Generic Hardware Error Source).  Firmware first
@@ -144,122 +185,174 @@ HEST   Section 18.3.2 (signature == "HEST")
        is recommended this table be supplied.
 
 HPET   Signature Reserved (signature == "HPET")
-       == High Precision Event timer Table ==
+
+       **High Precision Event timer Table**
+
        x86 only table, will not be supported.
 
 IBFT   Signature Reserved (signature == "IBFT")
-       == iSCSI Boot Firmware Table ==
+
+       **iSCSI Boot Firmware Table**
+
        Microsoft defined table, support TBD.
 
 IORT   Signature Reserved (signature == "IORT")
-       == Input Output Remapping Table ==
+
+       **Input Output Remapping Table**
+
        arm64 only table, required in order to describe IO topology, SMMUs,
        and GIC ITSs, and how those various components are connected together,
        such as identifying which components are behind which SMMUs/ITSs.
        This table will only be required on certain SBSA platforms (e.g.,
-       when using GICv3-ITS and an SMMU); on SBSA Level 0 platforms, it 
+       when using GICv3-ITS and an SMMU); on SBSA Level 0 platforms, it
        remains optional.
 
 IVRS   Signature Reserved (signature == "IVRS")
-       == I/O Virtualization Reporting Structure ==
+
+       **I/O Virtualization Reporting Structure**
+
        x86_64 (AMD) only table, will not be supported.
 
 LPIT   Signature Reserved (signature == "LPIT")
-       == Low Power Idle Table ==
+
+       **Low Power Idle Table**
+
        x86 only table as of ACPI 5.1; starting with ACPI 6.0, processor
        descriptions and power states on ARM platforms should use the DSDT
        and define processor container devices (_HID ACPI0010, Section 8.4,
        and more specifically 8.4.3 and and 8.4.4).
 
 MADT   Section 5.2.12 (signature == "APIC")
-       == Multiple APIC Description Table ==
+
+       **Multiple APIC Description Table**
+
        Required for arm64.  Only the GIC interrupt controller structures
        should be used (types 0xA - 0xF).
 
 MCFG   Signature Reserved (signature == "MCFG")
-       == Memory-mapped ConFiGuration space ==
+
+       **Memory-mapped ConFiGuration space**
+
        If the platform supports PCI/PCIe, an MCFG table is required.
 
 MCHI   Signature Reserved (signature == "MCHI")
-       == Management Controller Host Interface table ==
+
+       **Management Controller Host Interface table**
+
        Optional, not currently supported.
 
 MPST   Section 5.2.21 (signature == "MPST")
-       == Memory Power State Table ==
+
+       **Memory Power State Table**
+
        Optional, not currently supported.
 
 MSCT   Section 5.2.19 (signature == "MSCT")
-       == Maximum System Characteristic Table ==
+
+       **Maximum System Characteristic Table**
+
        Optional, not currently supported.
 
 MSDM   Signature Reserved (signature == "MSDM")
-       == Microsoft Data Management table ==
+
+       **Microsoft Data Management table**
+
        Microsoft only table, will not be supported.
 
 NFIT   Section 5.2.25 (signature == "NFIT")
-       == NVDIMM Firmware Interface Table ==
+
+       **NVDIMM Firmware Interface Table**
+
        Optional, not currently supported.
 
 OEMx   Signature of "OEMx" only
-       == OEM Specific Tables ==
+
+       **OEM Specific Tables**
+
        All tables starting with a signature of "OEM" are reserved for OEM
        use.  Since these are not meant to be of general use but are limited
        to very specific end users, they are not recommended for use and are
        not supported by the kernel for arm64.
 
 PCCT   Section 14.1 (signature == "PCCT)
-       == Platform Communications Channel Table ==
+
+       **Platform Communications Channel Table**
+
        Recommend for use on arm64; use of PCC is recommended when using CPPC
        to control performance and power for platform processors.
 
 PMTT   Section 5.2.21.12 (signature == "PMTT")
-       == Platform Memory Topology Table ==
+
+       **Platform Memory Topology Table**
+
        Optional, not currently supported.
 
 PSDT   Section 5.2.11.3 (signature == "PSDT")
-       == Persistent System Description Table ==
+
+       **Persistent System Description Table**
+
        Obsolete table, will not be supported.
 
 RASF   Section 5.2.20 (signature == "RASF")
-       == RAS Feature table ==
+
+       **RAS Feature table**
+
        Optional, not currently supported.
 
 RSDP   Section 5.2.5 (signature == "RSD PTR")
-       == Root System Description PoinTeR ==
+
+       **Root System Description PoinTeR**
+
        Required for arm64.
 
 RSDT   Section 5.2.7 (signature == "RSDT")
-       == Root System Description Table ==
+
+       **Root System Description Table**
+
        Since this table can only provide 32-bit addresses, it is deprecated
        on arm64, and will not be used.  If provided, it will be ignored.
 
 SBST   Section 5.2.14 (signature == "SBST")
-       == Smart Battery Subsystem Table ==
+
+       **Smart Battery Subsystem Table**
+
        Optional, not currently supported.
 
 SLIC   Signature Reserved (signature == "SLIC")
-       == Software LIcensing table ==
+
+       **Software LIcensing table**
+
        Microsoft only table, will not be supported.
 
 SLIT   Section 5.2.17 (signature == "SLIT")
-       == System Locality distance Information Table ==
+
+       **System Locality distance Information Table**
+
        Optional in general, but required for NUMA systems.
 
 SPCR   Signature Reserved (signature == "SPCR")
-       == Serial Port Console Redirection table ==
+
+       **Serial Port Console Redirection table**
+
        Required for arm64.
 
 SPMI   Signature Reserved (signature == "SPMI")
-       == Server Platform Management Interface table ==
+
+       **Server Platform Management Interface table**
+
        Optional, not currently supported.
 
 SRAT   Section 5.2.16 (signature == "SRAT")
-       == System Resource Affinity Table ==
+
+       **System Resource Affinity Table**
+
        Optional, but if used, only the GICC Affinity structures are read.
        To support arm64 NUMA, this table is required.
 
 SSDT   Section 5.2.11.2 (signature == "SSDT")
-       == Secondary System Description Table ==
+
+       **Secondary System Description Table**
+
        These tables are a continuation of the DSDT; these are recommended
        for use with devices that can be added to a running system, but can
        also serve the purpose of dividing up device descriptions into more
@@ -272,49 +365,69 @@ SSDT   Section 5.2.11.2 (signature == "SSDT")
        one DSDT but can contain many SSDTs.
 
 STAO   Signature Reserved (signature == "STAO")
-       == _STA Override table ==
+
+       **_STA Override table**
+
        Optional, but only necessary in virtualized environments in order to
        hide devices from guest OSs.
 
 TCPA   Signature Reserved (signature == "TCPA")
-       == Trusted Computing Platform Alliance table ==
+
+       **Trusted Computing Platform Alliance table**
+
        Optional, not currently supported, and may need changes to fully
        interoperate with arm64.
 
 TPM2   Signature Reserved (signature == "TPM2")
-       == Trusted Platform Module 2 table ==
+
+       **Trusted Platform Module 2 table**
+
        Optional, not currently supported, and may need changes to fully
        interoperate with arm64.
 
 UEFI   Signature Reserved (signature == "UEFI")
-       == UEFI ACPI data table ==
+
+       **UEFI ACPI data table**
+
        Optional, not currently supported.  No known use case for arm64,
        at present.
 
 WAET   Signature Reserved (signature == "WAET")
-       == Windows ACPI Emulated devices Table ==
+
+       **Windows ACPI Emulated devices Table**
+
        Microsoft only table, will not be supported.
 
 WDAT   Signature Reserved (signature == "WDAT")
-       == Watch Dog Action Table ==
+
+       **Watch Dog Action Table**
+
        Microsoft only table, will not be supported.
 
 WDRT   Signature Reserved (signature == "WDRT")
-       == Watch Dog Resource Table ==
+
+       **Watch Dog Resource Table**
+
        Microsoft only table, will not be supported.
 
 WPBT   Signature Reserved (signature == "WPBT")
-       == Windows Platform Binary Table ==
+
+       **Windows Platform Binary Table**
+
        Microsoft only table, will not be supported.
 
 XENV   Signature Reserved (signature == "XENV")
-       == Xen project table ==
+
+       **Xen project table**
+
        Optional, used only by Xen at present.
 
 XSDT   Section 5.2.8 (signature == "XSDT")
-       == eXtended System Description Table ==
+
+       **eXtended System Description Table**
+
        Required for arm64.
-
+====== ========================================================================
 
 ACPI Objects
 ------------
@@ -323,10 +436,11 @@ shown in the list that follows; any object not explicitly mentioned below
 should be used as needed for a particular platform or particular subsystem,
 such as power management or PCI.
 
+===== ================ ========================================================
 Name   Section         Usage for ARMv8 Linux
-----   ------------    -------------------------------------------------
+===== ================ ========================================================
 _CCA   6.2.17          This method must be defined for all bus masters
-                       on arm64 -- there are no assumptions made about
+                       on arm64 - there are no assumptions made about
                        whether such devices are cache coherent or not.
                        The _CCA value is inherited by all descendants of
                        these devices so it does not need to be repeated.
@@ -422,8 +536,8 @@ _OSC   6.2.11          This method can be a global method in ACPI (i.e.,
                        by the kernel community, then register it with the
                        UEFI Forum.
 
-\_OSI  5.7.2           Deprecated on ARM64.  As far as ACPI firmware is 
-		       concerned, _OSI is not to be used to determine what 
+\_OSI  5.7.2           Deprecated on ARM64.  As far as ACPI firmware is
+		       concerned, _OSI is not to be used to determine what
 		       sort of system is being used or what functionality
 		       is provided.  The _OSC method is to be used instead.
 
@@ -447,7 +561,7 @@ _PSx   7.3.2-5         Use as needed; power management specific.  If _PS0 is
                        usage, change them in these methods.
 
 _RDI   8.4.4.4         Recommended for use with processor definitions (_HID
-		       ACPI0010) on arm64.  This should only be used in 
+		       ACPI0010) on arm64.  This should only be used in
 		       conjunction with _LPI.
 
 \_REV  5.7.4           Always returns the latest version of ACPI supported.
@@ -476,6 +590,7 @@ _SWS   7.4.3           Use as needed; power management specific; this may
 
 _UID   6.1.12          Recommended for distinguishing devices of the same
                        class; define it if at all possible.
+===== ================ ========================================================
 
 
 
@@ -488,7 +603,7 @@ platforms, ACPI events must be signaled differently.
 
 There are two options: GPIO-signaled interrupts (Section 5.6.5), and
 interrupt-signaled events (Section 5.6.9).  Interrupt-signaled events are a
-new feature in the ACPI 6.1 specification.  Either -- or both -- can be used
+new feature in the ACPI 6.1 specification.  Either - or both - can be used
 on a given platform, and which to use may be dependent of limitations in any
 given SoC.  If possible, interrupt-signaled events are recommended.
 
@@ -564,39 +679,40 @@ supported.
 
 The following classes of objects are not supported:
 
-       -- Section 9.2: ambient light sensor devices
+       -  Section 9.2: ambient light sensor devices
 
-       -- Section 9.3: battery devices
+       -  Section 9.3: battery devices
 
-       -- Section 9.4: lids (e.g., laptop lids)
+       -  Section 9.4: lids (e.g., laptop lids)
 
-       -- Section 9.8.2: IDE controllers
+       -  Section 9.8.2: IDE controllers
 
-       -- Section 9.9: floppy controllers
+       -  Section 9.9: floppy controllers
 
-       -- Section 9.10: GPE block devices
+       -  Section 9.10: GPE block devices
 
-       -- Section 9.15: PC/AT RTC/CMOS devices
+       -  Section 9.15: PC/AT RTC/CMOS devices
 
-       -- Section 9.16: user presence detection devices
+       -  Section 9.16: user presence detection devices
 
-       -- Section 9.17: I/O APIC devices; all GICs must be enumerable via MADT
+       -  Section 9.17: I/O APIC devices; all GICs must be enumerable via MADT
 
-       -- Section 9.18: time and alarm devices (see 9.15)
+       -  Section 9.18: time and alarm devices (see 9.15)
 
-       -- Section 10: power source and power meter devices
+       -  Section 10: power source and power meter devices
 
-       -- Section 11: thermal management
+       -  Section 11: thermal management
 
-       -- Section 12: embedded controllers interface
+       -  Section 12: embedded controllers interface
 
-       -- Section 13: SMBus interfaces
+       -  Section 13: SMBus interfaces
 
 
 This also means that there is no support for the following objects:
 
+====   =========================== ====   ==========
 Name   Section                     Name   Section
-----   ------------                ----   ------------
+====   =========================== ====   ==========
 _ALC   9.3.4                       _FDM   9.10.3
 _ALI   9.3.2                       _FIX   6.2.7
 _ALP   9.3.6                       _GAI   10.4.5
@@ -619,4 +735,4 @@ _DCK   6.5.2                       _UPD   9.16.1
 _EC    12.12                       _UPP   9.16.2
 _FDE   9.10.1                      _WPC   10.5.2
 _FDI   9.10.2                      _WPP   10.5.3
-
+====   =========================== ====   ==========
diff --git a/Documentation/arm64/arm-acpi.txt b/Documentation/arm64/arm-acpi.rst
similarity index 86%
rename from Documentation/arm64/arm-acpi.txt
rename to Documentation/arm64/arm-acpi.rst
index 1a74a041a443..872dbbc73d4a 100644
--- a/Documentation/arm64/arm-acpi.txt
+++ b/Documentation/arm64/arm-acpi.rst
@@ -1,5 +1,7 @@
+=====================
 ACPI on ARMv8 Servers
----------------------
+=====================
+
 ACPI can be used for ARMv8 general purpose servers designed to follow
 the ARM SBSA (Server Base System Architecture) [0] and SBBR (Server
 Base Boot Requirements) [1] specifications.  Please note that the SBBR
@@ -34,28 +36,28 @@ of the summary text almost directly, to be honest.
 
 The short form of the rationale for ACPI on ARM is:
 
--- ACPI’s byte code (AML) allows the platform to encode hardware behavior,
+-  ACPI’s byte code (AML) allows the platform to encode hardware behavior,
    while DT explicitly does not support this.  For hardware vendors, being
    able to encode behavior is a key tool used in supporting operating
    system releases on new hardware.
 
--- ACPI’s OSPM defines a power management model that constrains what the
+-  ACPI’s OSPM defines a power management model that constrains what the
    platform is allowed to do into a specific model, while still providing
    flexibility in hardware design.
 
--- In the enterprise server environment, ACPI has established bindings (such
+-  In the enterprise server environment, ACPI has established bindings (such
    as for RAS) which are currently used in production systems.  DT does not.
    Such bindings could be defined in DT at some point, but doing so means ARM
    and x86 would end up using completely different code paths in both firmware
    and the kernel.
 
--- Choosing a single interface to describe the abstraction between a platform
+-  Choosing a single interface to describe the abstraction between a platform
    and an OS is important.  Hardware vendors would not be required to implement
    both DT and ACPI if they want to support multiple operating systems.  And,
    agreeing on a single interface instead of being fragmented into per OS
    interfaces makes for better interoperability overall.
 
--- The new ACPI governance process works well and Linux is now at the same
+-  The new ACPI governance process works well and Linux is now at the same
    table as hardware vendors and other OS vendors.  In fact, there is no
    longer any reason to feel that ACPI only belongs to Windows or that
    Linux is in any way secondary to Microsoft in this arena.  The move of
@@ -169,31 +171,31 @@ For the ACPI core to operate properly, and in turn provide the information
 the kernel needs to configure devices, it expects to find the following
 tables (all section numbers refer to the ACPI 6.1 specification):
 
-    -- RSDP (Root System Description Pointer), section 5.2.5
+    -  RSDP (Root System Description Pointer), section 5.2.5
 
-    -- XSDT (eXtended System Description Table), section 5.2.8
+    -  XSDT (eXtended System Description Table), section 5.2.8
 
-    -- FADT (Fixed ACPI Description Table), section 5.2.9
+    -  FADT (Fixed ACPI Description Table), section 5.2.9
 
-    -- DSDT (Differentiated System Description Table), section
+    -  DSDT (Differentiated System Description Table), section
        5.2.11.1
 
-    -- MADT (Multiple APIC Description Table), section 5.2.12
+    -  MADT (Multiple APIC Description Table), section 5.2.12
 
-    -- GTDT (Generic Timer Description Table), section 5.2.24
+    -  GTDT (Generic Timer Description Table), section 5.2.24
 
-    -- If PCI is supported, the MCFG (Memory mapped ConFiGuration
+    -  If PCI is supported, the MCFG (Memory mapped ConFiGuration
        Table), section 5.2.6, specifically Table 5-31.
 
-    -- If booting without a console=<device> kernel parameter is
+    -  If booting without a console=<device> kernel parameter is
        supported, the SPCR (Serial Port Console Redirection table),
        section 5.2.6, specifically Table 5-31.
 
-    -- If necessary to describe the I/O topology, SMMUs and GIC ITSs,
+    -  If necessary to describe the I/O topology, SMMUs and GIC ITSs,
        the IORT (Input Output Remapping Table, section 5.2.6, specifically
        Table 5-31).
 
-    -- If NUMA is supported, the SRAT (System Resource Affinity Table)
+    -  If NUMA is supported, the SRAT (System Resource Affinity Table)
        and SLIT (System Locality distance Information Table), sections
        5.2.16 and 5.2.17, respectively.
 
@@ -269,9 +271,9 @@ describes how to define the structure of an object returned via _DSD, and
 how specific data structures are defined by specific UUIDs.  Linux should
 only use the _DSD Device Properties UUID [5]:
 
-   -- UUID: daffd814-6eba-4d8c-8a91-bc9bbf4aa301
+   - UUID: daffd814-6eba-4d8c-8a91-bc9bbf4aa301
 
-   -- http://www.uefi.org/sites/default/files/resources/_DSD-device-properties-UUID.pdf
+   - http://www.uefi.org/sites/default/files/resources/_DSD-device-properties-UUID.pdf
 
 The UEFI Forum provides a mechanism for registering device properties [4]
 so that they may be used across all operating systems supporting ACPI.
@@ -327,10 +329,10 @@ turning a device full off.
 
 There are two options for using those Power Resources.  They can:
 
-   -- be managed in a _PSx method which gets called on entry to power
+   -  be managed in a _PSx method which gets called on entry to power
       state Dx.
 
-   -- be declared separately as power resources with their own _ON and _OFF
+   -  be declared separately as power resources with their own _ON and _OFF
       methods.  They are then tied back to D-states for a particular device
       via _PRx which specifies which power resources a device needs to be on
       while in Dx.  Kernel then tracks number of devices using a power resource
@@ -339,16 +341,16 @@ There are two options for using those Power Resources.  They can:
 The kernel ACPI code will also assume that the _PSx methods follow the normal
 ACPI rules for such methods:
 
-   -- If either _PS0 or _PS3 is implemented, then the other method must also
+   -  If either _PS0 or _PS3 is implemented, then the other method must also
       be implemented.
 
-   -- If a device requires usage or setup of a power resource when on, the ASL
+   -  If a device requires usage or setup of a power resource when on, the ASL
       should organize that it is allocated/enabled using the _PS0 method.
 
-   -- Resources allocated or enabled in the _PS0 method should be disabled
+   -  Resources allocated or enabled in the _PS0 method should be disabled
       or de-allocated in the _PS3 method.
 
-   -- Firmware will leave the resources in a reasonable state before handing
+   -  Firmware will leave the resources in a reasonable state before handing
       over control to the kernel.
 
 Such code in _PSx methods will of course be very platform specific.  But,
@@ -394,52 +396,52 @@ else must be discovered by the driver probe function.  Then, have the rest
 of the driver operate off of the contents of that struct.  Doing so should
 allow most divergence between ACPI and DT functionality to be kept local to
 the probe function instead of being scattered throughout the driver.  For
-example:
+example::
 
-static int device_probe_dt(struct platform_device *pdev)
-{
-       /* DT specific functionality */
-       ...
-}
+  static int device_probe_dt(struct platform_device *pdev)
+  {
+         /* DT specific functionality */
+         ...
+  }
 
-static int device_probe_acpi(struct platform_device *pdev)
-{
-       /* ACPI specific functionality */
-       ...
-}
+  static int device_probe_acpi(struct platform_device *pdev)
+  {
+         /* ACPI specific functionality */
+         ...
+  }
 
-static int device_probe(struct platform_device *pdev)
-{
-       ...
-       struct device_node node = pdev->dev.of_node;
-       ...
+  static int device_probe(struct platform_device *pdev)
+  {
+         ...
+         struct device_node node = pdev->dev.of_node;
+         ...
 
-       if (node)
-               ret = device_probe_dt(pdev);
-       else if (ACPI_HANDLE(&pdev->dev))
-               ret = device_probe_acpi(pdev);
-       else
-               /* other initialization */
-               ...
-       /* Continue with any generic probe operations */
-       ...
-}
+         if (node)
+                 ret = device_probe_dt(pdev);
+         else if (ACPI_HANDLE(&pdev->dev))
+                 ret = device_probe_acpi(pdev);
+         else
+                 /* other initialization */
+                 ...
+         /* Continue with any generic probe operations */
+         ...
+  }
 
 DO keep the MODULE_DEVICE_TABLE entries together in the driver to make it
 clear the different names the driver is probed for, both from DT and from
-ACPI:
+ACPI::
 
-static struct of_device_id virtio_mmio_match[] = {
-        { .compatible = "virtio,mmio", },
-        { }
-};
-MODULE_DEVICE_TABLE(of, virtio_mmio_match);
+  static struct of_device_id virtio_mmio_match[] = {
+          { .compatible = "virtio,mmio", },
+          { }
+  };
+  MODULE_DEVICE_TABLE(of, virtio_mmio_match);
 
-static const struct acpi_device_id virtio_mmio_acpi_match[] = {
-        { "LNRO0005", },
-        { }
-};
-MODULE_DEVICE_TABLE(acpi, virtio_mmio_acpi_match);
+  static const struct acpi_device_id virtio_mmio_acpi_match[] = {
+          { "LNRO0005", },
+          { }
+  };
+  MODULE_DEVICE_TABLE(acpi, virtio_mmio_acpi_match);
 
 
 ASWG
@@ -471,7 +473,8 @@ Linux Code
 Individual items specific to Linux on ARM, contained in the the Linux
 source code, are in the list that follows:
 
-ACPI_OS_NAME           This macro defines the string to be returned when
+ACPI_OS_NAME
+                       This macro defines the string to be returned when
                        an ACPI method invokes the _OS method.  On ARM64
                        systems, this macro will be "Linux" by default.
                        The command line parameter acpi_os=<string>
@@ -482,38 +485,44 @@ ACPI_OS_NAME           This macro defines the string to be returned when
 ACPI Objects
 ------------
 Detailed expectations for ACPI tables and object are listed in the file
-Documentation/arm64/acpi_object_usage.txt.
+Documentation/arm64/acpi_object_usage.rst.
 
 
 References
 ----------
-[0] http://silver.arm.com -- document ARM-DEN-0029, or newer
+[0] http://silver.arm.com
+    document ARM-DEN-0029, or newer:
     "Server Base System Architecture", version 2.3, dated 27 Mar 2014
 
 [1] http://infocenter.arm.com/help/topic/com.arm.doc.den0044a/Server_Base_Boot_Requirements.pdf
     Document ARM-DEN-0044A, or newer: "Server Base Boot Requirements, System
     Software on ARM Platforms", dated 16 Aug 2014
 
-[2] http://www.secretlab.ca/archives/151, 10 Jan 2015, Copyright (c) 2015,
+[2] http://www.secretlab.ca/archives/151,
+    10 Jan 2015, Copyright (c) 2015,
     Linaro Ltd., written by Grant Likely.
 
-[3] AMD ACPI for Seattle platform documentation:
+[3] AMD ACPI for Seattle platform documentation
     http://amd-dev.wpengine.netdna-cdn.com/wordpress/media/2012/10/Seattle_ACPI_Guide.pdf
 
-[4] http://www.uefi.org/acpi -- please see the link for the "ACPI _DSD Device
+
+[4] http://www.uefi.org/acpi
+    please see the link for the "ACPI _DSD Device
     Property Registry Instructions"
 
-[5] http://www.uefi.org/acpi -- please see the link for the "_DSD (Device
+[5] http://www.uefi.org/acpi
+    please see the link for the "_DSD (Device
     Specific Data) Implementation Guide"
 
-[6] Kernel code for the unified device property interface can be found in
+[6] Kernel code for the unified device
+    property interface can be found in
     include/linux/property.h and drivers/base/property.c.
 
 
 Authors
 -------
-Al Stone <al.stone@linaro.org>
-Graeme Gregory <graeme.gregory@linaro.org>
-Hanjun Guo <hanjun.guo@linaro.org>
+- Al Stone <al.stone@linaro.org>
+- Graeme Gregory <graeme.gregory@linaro.org>
+- Hanjun Guo <hanjun.guo@linaro.org>
 
-Grant Likely <grant.likely@linaro.org>, for the "Why ACPI on ARM?" section
+- Grant Likely <grant.likely@linaro.org>, for the "Why ACPI on ARM?" section
diff --git a/Documentation/arm64/booting.txt b/Documentation/arm64/booting.rst
similarity index 86%
rename from Documentation/arm64/booting.txt
rename to Documentation/arm64/booting.rst
index fbab7e21d116..3d041d0d16e8 100644
--- a/Documentation/arm64/booting.txt
+++ b/Documentation/arm64/booting.rst
@@ -1,7 +1,9 @@
-			Booting AArch64 Linux
-			=====================
+=====================
+Booting AArch64 Linux
+=====================
 
 Author: Will Deacon <will.deacon@arm.com>
+
 Date  : 07 September 2012
 
 This document is based on the ARM booting document by Russell King and
@@ -12,7 +14,7 @@ The AArch64 exception model is made up of a number of exception levels
 counterpart.  EL2 is the hypervisor level and exists only in non-secure
 mode. EL3 is the highest priority level and exists only in secure mode.
 
-For the purposes of this document, we will use the term `boot loader'
+For the purposes of this document, we will use the term `boot loader`
 simply to define all software that executes on the CPU(s) before control
 is passed to the Linux kernel.  This may include secure monitor and
 hypervisor code, or it may just be a handful of instructions for
@@ -70,7 +72,7 @@ Image target is available instead.
 
 Requirement: MANDATORY
 
-The decompressed kernel image contains a 64-byte header as follows:
+The decompressed kernel image contains a 64-byte header as follows::
 
   u32 code0;			/* Executable code */
   u32 code1;			/* Executable code */
@@ -103,19 +105,26 @@ Header notes:
 
 - The flags field (introduced in v3.17) is a little-endian 64-bit field
   composed as follows:
-  Bit 0:	Kernel endianness.  1 if BE, 0 if LE.
-  Bit 1-2:	Kernel Page size.
-			0 - Unspecified.
-			1 - 4K
-			2 - 16K
-			3 - 64K
-  Bit 3:	Kernel physical placement
-			0 - 2MB aligned base should be as close as possible
-			    to the base of DRAM, since memory below it is not
-			    accessible via the linear mapping
-			1 - 2MB aligned base may be anywhere in physical
-			    memory
-  Bits 4-63:	Reserved.
+
+  ============= ===============================================================
+  Bit 0		Kernel endianness.  1 if BE, 0 if LE.
+  Bit 1-2	Kernel Page size.
+
+			* 0 - Unspecified.
+			* 1 - 4K
+			* 2 - 16K
+			* 3 - 64K
+  Bit 3		Kernel physical placement
+
+			0
+			  2MB aligned base should be as close as possible
+			  to the base of DRAM, since memory below it is not
+			  accessible via the linear mapping
+			1
+			  2MB aligned base may be anywhere in physical
+			  memory
+  Bits 4-63	Reserved.
+  ============= ===============================================================
 
 - When image_size is zero, a bootloader should attempt to keep as much
   memory as possible free for use by the kernel immediately after the
@@ -147,19 +156,22 @@ Before jumping into the kernel, the following conditions must be met:
   corrupted by bogus network packets or disk data.  This will save
   you many hours of debug.
 
-- Primary CPU general-purpose register settings
-  x0 = physical address of device tree blob (dtb) in system RAM.
-  x1 = 0 (reserved for future use)
-  x2 = 0 (reserved for future use)
-  x3 = 0 (reserved for future use)
+- Primary CPU general-purpose register settings:
+
+    - x0 = physical address of device tree blob (dtb) in system RAM.
+    - x1 = 0 (reserved for future use)
+    - x2 = 0 (reserved for future use)
+    - x3 = 0 (reserved for future use)
 
 - CPU mode
+
   All forms of interrupts must be masked in PSTATE.DAIF (Debug, SError,
   IRQ and FIQ).
   The CPU must be in either EL2 (RECOMMENDED in order to have access to
   the virtualisation extensions) or non-secure EL1.
 
 - Caches, MMUs
+
   The MMU must be off.
   Instruction cache may be on or off.
   The address range corresponding to the loaded kernel image must be
@@ -172,18 +184,21 @@ Before jumping into the kernel, the following conditions must be met:
   operations (not recommended) must be configured and disabled.
 
 - Architected timers
+
   CNTFRQ must be programmed with the timer frequency and CNTVOFF must
   be programmed with a consistent value on all CPUs.  If entering the
   kernel at EL1, CNTHCTL_EL2 must have EL1PCTEN (bit 0) set where
   available.
 
 - Coherency
+
   All CPUs to be booted by the kernel must be part of the same coherency
   domain on entry to the kernel.  This may require IMPLEMENTATION DEFINED
   initialisation to enable the receiving of maintenance operations on
   each CPU.
 
 - System registers
+
   All writable architected system registers at the exception level where
   the kernel image will be entered must be initialised by software at a
   higher exception level to prevent execution in an UNKNOWN state.
@@ -195,28 +210,40 @@ Before jumping into the kernel, the following conditions must be met:
 
   For systems with a GICv3 interrupt controller to be used in v3 mode:
   - If EL3 is present:
-    ICC_SRE_EL3.Enable (bit 3) must be initialiased to 0b1.
-    ICC_SRE_EL3.SRE (bit 0) must be initialised to 0b1.
+
+      - ICC_SRE_EL3.Enable (bit 3) must be initialiased to 0b1.
+      - ICC_SRE_EL3.SRE (bit 0) must be initialised to 0b1.
+
   - If the kernel is entered at EL1:
-    ICC.SRE_EL2.Enable (bit 3) must be initialised to 0b1
-    ICC_SRE_EL2.SRE (bit 0) must be initialised to 0b1.
+
+      - ICC.SRE_EL2.Enable (bit 3) must be initialised to 0b1
+      - ICC_SRE_EL2.SRE (bit 0) must be initialised to 0b1.
+
   - The DT or ACPI tables must describe a GICv3 interrupt controller.
 
   For systems with a GICv3 interrupt controller to be used in
   compatibility (v2) mode:
+
   - If EL3 is present:
-    ICC_SRE_EL3.SRE (bit 0) must be initialised to 0b0.
+
+      ICC_SRE_EL3.SRE (bit 0) must be initialised to 0b0.
+
   - If the kernel is entered at EL1:
-    ICC_SRE_EL2.SRE (bit 0) must be initialised to 0b0.
+
+      ICC_SRE_EL2.SRE (bit 0) must be initialised to 0b0.
+
   - The DT or ACPI tables must describe a GICv2 interrupt controller.
 
   For CPUs with pointer authentication functionality:
   - If EL3 is present:
-    SCR_EL3.APK (bit 16) must be initialised to 0b1
-    SCR_EL3.API (bit 17) must be initialised to 0b1
+
+    - SCR_EL3.APK (bit 16) must be initialised to 0b1
+    - SCR_EL3.API (bit 17) must be initialised to 0b1
+
   - If the kernel is entered at EL1:
-    HCR_EL2.APK (bit 40) must be initialised to 0b1
-    HCR_EL2.API (bit 41) must be initialised to 0b1
+
+    - HCR_EL2.APK (bit 40) must be initialised to 0b1
+    - HCR_EL2.API (bit 41) must be initialised to 0b1
 
 The requirements described above for CPU mode, caches, MMUs, architected
 timers, coherency and system registers apply to all CPUs.  All CPUs must
diff --git a/Documentation/arm64/cpu-feature-registers.txt b/Documentation/arm64/cpu-feature-registers.rst
similarity index 65%
rename from Documentation/arm64/cpu-feature-registers.txt
rename to Documentation/arm64/cpu-feature-registers.rst
index 684a0da39378..2955287e9acc 100644
--- a/Documentation/arm64/cpu-feature-registers.txt
+++ b/Documentation/arm64/cpu-feature-registers.rst
@@ -1,5 +1,6 @@
-		ARM64 CPU Feature Registers
-		===========================
+===========================
+ARM64 CPU Feature Registers
+===========================
 
 Author: Suzuki K Poulose <suzuki.poulose@arm.com>
 
@@ -9,7 +10,7 @@ registers to userspace. The availability of this ABI is advertised
 via the HWCAP_CPUID in HWCAPs.
 
 1. Motivation
----------------
+-------------
 
 The ARM architecture defines a set of feature registers, which describe
 the capabilities of the CPU/system. Access to these system registers is
@@ -33,9 +34,10 @@ there are some issues with their usage.
 
 
 2. Requirements
------------------
+---------------
+
+ a) Safety:
 
- a) Safety :
     Applications should be able to use the information provided by the
     infrastructure to run safely across the system. This has greater
     implications on a system with heterogeneous CPUs.
@@ -47,7 +49,8 @@ there are some issues with their usage.
     Otherwise an application could crash when scheduled on the CPU
     which doesn't support CRC32.
 
- b) Security :
+ b) Security:
+
     Applications should only be able to receive information that is
     relevant to the normal operation in userspace. Hence, some of the
     fields are masked out(i.e, made invisible) and their values are set to
@@ -58,10 +61,12 @@ there are some issues with their usage.
     (even when the CPU provides it).
 
  c) Implementation Defined Features
+
     The infrastructure doesn't expose any register which is
     IMPLEMENTATION DEFINED as per ARMv8-A Architecture.
 
- d) CPU Identification :
+ d) CPU Identification:
+
     MIDR_EL1 is exposed to help identify the processor. On a
     heterogeneous system, this could be racy (just like getcpu()). The
     process could be migrated to another CPU by the time it uses the
@@ -70,7 +75,7 @@ there are some issues with their usage.
     currently executing on. The REVIDR is not exposed due to this
     constraint, as REVIDR makes sense only in conjunction with the
     MIDR. Alternately, MIDR_EL1 and REVIDR_EL1 are exposed via sysfs
-    at:
+    at::
 
 	/sys/devices/system/cpu/cpu$ID/regs/identification/
 	                                              \- midr
@@ -85,7 +90,8 @@ exception and ends up in SIGILL being delivered to the process.
 The infrastructure hooks into the exception handler and emulates the
 operation if the source belongs to the supported system register space.
 
-The infrastructure emulates only the following system register space:
+The infrastructure emulates only the following system register space::
+
 	Op0=3, Op1=0, CRn=0, CRm=0,4,5,6,7
 
 (See Table C5-6 'System instruction encodings for non-Debug System
@@ -107,73 +113,76 @@ infrastructure:
 -------------------------------------------
 
   1) ID_AA64ISAR0_EL1 - Instruction Set Attribute Register 0
-     x--------------------------------------------------x
+
+     +------------------------------+---------+---------+
      | Name                         |  bits   | visible |
-     |--------------------------------------------------|
+     +------------------------------+---------+---------+
      | TS                           | [55-52] |    y    |
-     |--------------------------------------------------|
+     +------------------------------+---------+---------+
      | FHM                          | [51-48] |    y    |
-     |--------------------------------------------------|
+     +------------------------------+---------+---------+
      | DP                           | [47-44] |    y    |
-     |--------------------------------------------------|
+     +------------------------------+---------+---------+
      | SM4                          | [43-40] |    y    |
-     |--------------------------------------------------|
+     +------------------------------+---------+---------+
      | SM3                          | [39-36] |    y    |
-     |--------------------------------------------------|
+     +------------------------------+---------+---------+
      | SHA3                         | [35-32] |    y    |
-     |--------------------------------------------------|
+     +------------------------------+---------+---------+
      | RDM                          | [31-28] |    y    |
-     |--------------------------------------------------|
+     +------------------------------+---------+---------+
      | ATOMICS                      | [23-20] |    y    |
-     |--------------------------------------------------|
+     +------------------------------+---------+---------+
      | CRC32                        | [19-16] |    y    |
-     |--------------------------------------------------|
+     +------------------------------+---------+---------+
      | SHA2                         | [15-12] |    y    |
-     |--------------------------------------------------|
+     +------------------------------+---------+---------+
      | SHA1                         | [11-8]  |    y    |
-     |--------------------------------------------------|
+     +------------------------------+---------+---------+
      | AES                          | [7-4]   |    y    |
-     x--------------------------------------------------x
+     +------------------------------+---------+---------+
 
 
   2) ID_AA64PFR0_EL1 - Processor Feature Register 0
-     x--------------------------------------------------x
+
+     +------------------------------+---------+---------+
      | Name                         |  bits   | visible |
-     |--------------------------------------------------|
+     +------------------------------+---------+---------+
      | DIT                          | [51-48] |    y    |
-     |--------------------------------------------------|
+     +------------------------------+---------+---------+
      | SVE                          | [35-32] |    y    |
-     |--------------------------------------------------|
+     +------------------------------+---------+---------+
      | GIC                          | [27-24] |    n    |
-     |--------------------------------------------------|
+     +------------------------------+---------+---------+
      | AdvSIMD                      | [23-20] |    y    |
-     |--------------------------------------------------|
+     +------------------------------+---------+---------+
      | FP                           | [19-16] |    y    |
-     |--------------------------------------------------|
+     +------------------------------+---------+---------+
      | EL3                          | [15-12] |    n    |
-     |--------------------------------------------------|
+     +------------------------------+---------+---------+
      | EL2                          | [11-8]  |    n    |
-     |--------------------------------------------------|
+     +------------------------------+---------+---------+
      | EL1                          | [7-4]   |    n    |
-     |--------------------------------------------------|
+     +------------------------------+---------+---------+
      | EL0                          | [3-0]   |    n    |
-     x--------------------------------------------------x
+     +------------------------------+---------+---------+
 
 
   3) MIDR_EL1 - Main ID Register
-     x--------------------------------------------------x
+
+     +------------------------------+---------+---------+
      | Name                         |  bits   | visible |
-     |--------------------------------------------------|
+     +------------------------------+---------+---------+
      | Implementer                  | [31-24] |    y    |
-     |--------------------------------------------------|
+     +------------------------------+---------+---------+
      | Variant                      | [23-20] |    y    |
-     |--------------------------------------------------|
+     +------------------------------+---------+---------+
      | Architecture                 | [19-16] |    y    |
-     |--------------------------------------------------|
+     +------------------------------+---------+---------+
      | PartNum                      | [15-4]  |    y    |
-     |--------------------------------------------------|
+     +------------------------------+---------+---------+
      | Revision                     | [3-0]   |    y    |
-     x--------------------------------------------------x
+     +------------------------------+---------+---------+
 
    NOTE: The 'visible' fields of MIDR_EL1 will contain the value
    as available on the CPU where it is fetched and is not a system
@@ -181,90 +190,92 @@ infrastructure:
 
   4) ID_AA64ISAR1_EL1 - Instruction set attribute register 1
 
-     x--------------------------------------------------x
+     +------------------------------+---------+---------+
      | Name                         |  bits   | visible |
-     |--------------------------------------------------|
+     +------------------------------+---------+---------+
      | GPI                          | [31-28] |    y    |
-     |--------------------------------------------------|
+     +------------------------------+---------+---------+
      | GPA                          | [27-24] |    y    |
-     |--------------------------------------------------|
+     +------------------------------+---------+---------+
      | LRCPC                        | [23-20] |    y    |
-     |--------------------------------------------------|
+     +------------------------------+---------+---------+
      | FCMA                         | [19-16] |    y    |
-     |--------------------------------------------------|
+     +------------------------------+---------+---------+
      | JSCVT                        | [15-12] |    y    |
-     |--------------------------------------------------|
+     +------------------------------+---------+---------+
      | API                          | [11-8]  |    y    |
-     |--------------------------------------------------|
+     +------------------------------+---------+---------+
      | APA                          | [7-4]   |    y    |
-     |--------------------------------------------------|
+     +------------------------------+---------+---------+
      | DPB                          | [3-0]   |    y    |
-     x--------------------------------------------------x
+     +------------------------------+---------+---------+
 
   5) ID_AA64MMFR2_EL1 - Memory model feature register 2
 
-     x--------------------------------------------------x
+     +------------------------------+---------+---------+
      | Name                         |  bits   | visible |
-     |--------------------------------------------------|
+     +------------------------------+---------+---------+
      | AT                           | [35-32] |    y    |
-     x--------------------------------------------------x
+     +------------------------------+---------+---------+
 
   6) ID_AA64ZFR0_EL1 - SVE feature ID register 0
 
-     x--------------------------------------------------x
+     +------------------------------+---------+---------+
      | Name                         |  bits   | visible |
-     |--------------------------------------------------|
+     +------------------------------+---------+---------+
      | SM4                          | [43-40] |    y    |
-     |--------------------------------------------------|
+     +------------------------------+---------+---------+
      | SHA3                         | [35-32] |    y    |
-     |--------------------------------------------------|
+     +------------------------------+---------+---------+
      | BitPerm                      | [19-16] |    y    |
-     |--------------------------------------------------|
+     +------------------------------+---------+---------+
      | AES                          | [7-4]   |    y    |
-     |--------------------------------------------------|
+     +------------------------------+---------+---------+
      | SVEVer                       | [3-0]   |    y    |
-     x--------------------------------------------------x
+     +------------------------------+---------+---------+
 
 Appendix I: Example
----------------------------
+-------------------
 
-/*
- * Sample program to demonstrate the MRS emulation ABI.
- *
- * Copyright (C) 2015-2016, ARM Ltd
- *
- * Author: Suzuki K Poulose <suzuki.poulose@arm.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
+::
 
-#include <asm/hwcap.h>
-#include <stdio.h>
-#include <sys/auxv.h>
+  /*
+   * Sample program to demonstrate the MRS emulation ABI.
+   *
+   * Copyright (C) 2015-2016, ARM Ltd
+   *
+   * Author: Suzuki K Poulose <suzuki.poulose@arm.com>
+   *
+   * This program is free software; you can redistribute it and/or modify
+   * it under the terms of the GNU General Public License version 2 as
+   * published by the Free Software Foundation.
+   *
+   * This program is distributed in the hope that it will be useful,
+   * but WITHOUT ANY WARRANTY; without even the implied warranty of
+   * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+   * GNU General Public License for more details.
+   * This program is free software; you can redistribute it and/or modify
+   * it under the terms of the GNU General Public License version 2 as
+   * published by the Free Software Foundation.
+   *
+   * This program is distributed in the hope that it will be useful,
+   * but WITHOUT ANY WARRANTY; without even the implied warranty of
+   * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+   * GNU General Public License for more details.
+   */
 
-#define get_cpu_ftr(id) ({					\
+  #include <asm/hwcap.h>
+  #include <stdio.h>
+  #include <sys/auxv.h>
+
+  #define get_cpu_ftr(id) ({					\
 		unsigned long __val;				\
 		asm("mrs %0, "#id : "=r" (__val));		\
 		printf("%-20s: 0x%016lx\n", #id, __val);	\
 	})
 
-int main(void)
-{
+  int main(void)
+  {
 
 	if (!(getauxval(AT_HWCAP) & HWCAP_CPUID)) {
 		fputs("CPUID registers unavailable\n", stderr);
@@ -284,13 +295,10 @@ int main(void)
 	get_cpu_ftr(MPIDR_EL1);
 	get_cpu_ftr(REVIDR_EL1);
 
-#if 0
+  #if 0
 	/* Unexposed register access causes SIGILL */
 	get_cpu_ftr(ID_MMFR0_EL1);
-#endif
+  #endif
 
 	return 0;
-}
-
-
-
+  }
diff --git a/Documentation/arm64/elf_hwcaps.txt b/Documentation/arm64/elf_hwcaps.rst
similarity index 92%
rename from Documentation/arm64/elf_hwcaps.txt
rename to Documentation/arm64/elf_hwcaps.rst
index b73a2519ecf2..c7cbf4b571c0 100644
--- a/Documentation/arm64/elf_hwcaps.txt
+++ b/Documentation/arm64/elf_hwcaps.rst
@@ -1,3 +1,4 @@
+================
 ARM64 ELF hwcaps
 ================
 
@@ -15,16 +16,16 @@ of flags called hwcaps, exposed in the auxilliary vector.
 
 Userspace software can test for features by acquiring the AT_HWCAP or
 AT_HWCAP2 entry of the auxiliary vector, and testing whether the relevant
-flags are set, e.g.
+flags are set, e.g.::
 
-bool floating_point_is_present(void)
-{
-	unsigned long hwcaps = getauxval(AT_HWCAP);
-	if (hwcaps & HWCAP_FP)
-		return true;
+	bool floating_point_is_present(void)
+	{
+		unsigned long hwcaps = getauxval(AT_HWCAP);
+		if (hwcaps & HWCAP_FP)
+			return true;
 
-	return false;
-}
+		return false;
+	}
 
 Where software relies on a feature described by a hwcap, it should check
 the relevant hwcap flag to verify that the feature is present before
@@ -45,7 +46,7 @@ userspace code at EL0. These hwcaps are defined in terms of ID register
 fields, and should be interpreted with reference to the definition of
 these fields in the ARM Architecture Reference Manual (ARM ARM).
 
-Such hwcaps are described below in the form:
+Such hwcaps are described below in the form::
 
     Functionality implied by idreg.field == val.
 
@@ -64,75 +65,58 @@ reference to ID registers, and may refer to other documentation.
 ---------------------------------
 
 HWCAP_FP
-
     Functionality implied by ID_AA64PFR0_EL1.FP == 0b0000.
 
 HWCAP_ASIMD
-
     Functionality implied by ID_AA64PFR0_EL1.AdvSIMD == 0b0000.
 
 HWCAP_EVTSTRM
-
     The generic timer is configured to generate events at a frequency of
     approximately 100KHz.
 
 HWCAP_AES
-
     Functionality implied by ID_AA64ISAR0_EL1.AES == 0b0001.
 
 HWCAP_PMULL
-
     Functionality implied by ID_AA64ISAR0_EL1.AES == 0b0010.
 
 HWCAP_SHA1
-
     Functionality implied by ID_AA64ISAR0_EL1.SHA1 == 0b0001.
 
 HWCAP_SHA2
-
     Functionality implied by ID_AA64ISAR0_EL1.SHA2 == 0b0001.
 
 HWCAP_CRC32
-
     Functionality implied by ID_AA64ISAR0_EL1.CRC32 == 0b0001.
 
 HWCAP_ATOMICS
-
     Functionality implied by ID_AA64ISAR0_EL1.Atomic == 0b0010.
 
 HWCAP_FPHP
-
     Functionality implied by ID_AA64PFR0_EL1.FP == 0b0001.
 
 HWCAP_ASIMDHP
-
     Functionality implied by ID_AA64PFR0_EL1.AdvSIMD == 0b0001.
 
 HWCAP_CPUID
-
     EL0 access to certain ID registers is available, to the extent
-    described by Documentation/arm64/cpu-feature-registers.txt.
+    described by Documentation/arm64/cpu-feature-registers.rst.
 
     These ID registers may imply the availability of features.
 
 HWCAP_ASIMDRDM
-
     Functionality implied by ID_AA64ISAR0_EL1.RDM == 0b0001.
 
 HWCAP_JSCVT
-
     Functionality implied by ID_AA64ISAR1_EL1.JSCVT == 0b0001.
 
 HWCAP_FCMA
-
     Functionality implied by ID_AA64ISAR1_EL1.FCMA == 0b0001.
 
 HWCAP_LRCPC
-
     Functionality implied by ID_AA64ISAR1_EL1.LRCPC == 0b0001.
 
 HWCAP_DCPOP
-
     Functionality implied by ID_AA64ISAR1_EL1.DPB == 0b0001.
 
 HWCAP2_DCPODP
@@ -140,27 +124,21 @@ HWCAP2_DCPODP
     Functionality implied by ID_AA64ISAR1_EL1.DPB == 0b0010.
 
 HWCAP_SHA3
-
     Functionality implied by ID_AA64ISAR0_EL1.SHA3 == 0b0001.
 
 HWCAP_SM3
-
     Functionality implied by ID_AA64ISAR0_EL1.SM3 == 0b0001.
 
 HWCAP_SM4
-
     Functionality implied by ID_AA64ISAR0_EL1.SM4 == 0b0001.
 
 HWCAP_ASIMDDP
-
     Functionality implied by ID_AA64ISAR0_EL1.DP == 0b0001.
 
 HWCAP_SHA512
-
     Functionality implied by ID_AA64ISAR0_EL1.SHA2 == 0b0010.
 
 HWCAP_SVE
-
     Functionality implied by ID_AA64PFR0_EL1.SVE == 0b0001.
 
 HWCAP2_SVE2
@@ -188,40 +166,32 @@ HWCAP2_SVESM4
     Functionality implied by ID_AA64ZFR0_EL1.SM4 == 0b0001.
 
 HWCAP_ASIMDFHM
-
    Functionality implied by ID_AA64ISAR0_EL1.FHM == 0b0001.
 
 HWCAP_DIT
-
     Functionality implied by ID_AA64PFR0_EL1.DIT == 0b0001.
 
 HWCAP_USCAT
-
     Functionality implied by ID_AA64MMFR2_EL1.AT == 0b0001.
 
 HWCAP_ILRCPC
-
     Functionality implied by ID_AA64ISAR1_EL1.LRCPC == 0b0010.
 
 HWCAP_FLAGM
-
     Functionality implied by ID_AA64ISAR0_EL1.TS == 0b0001.
 
 HWCAP_SSBS
-
     Functionality implied by ID_AA64PFR1_EL1.SSBS == 0b0010.
 
 HWCAP_PACA
-
     Functionality implied by ID_AA64ISAR1_EL1.APA == 0b0001 or
     ID_AA64ISAR1_EL1.API == 0b0001, as described by
-    Documentation/arm64/pointer-authentication.txt.
+    Documentation/arm64/pointer-authentication.rst.
 
 HWCAP_PACG
-
     Functionality implied by ID_AA64ISAR1_EL1.GPA == 0b0001 or
     ID_AA64ISAR1_EL1.GPI == 0b0001, as described by
-    Documentation/arm64/pointer-authentication.txt.
+    Documentation/arm64/pointer-authentication.rst.
 
 
 4. Unused AT_HWCAP bits
diff --git a/Documentation/arm64/hugetlbpage.txt b/Documentation/arm64/hugetlbpage.rst
similarity index 86%
rename from Documentation/arm64/hugetlbpage.txt
rename to Documentation/arm64/hugetlbpage.rst
index cfae87dc653b..b44f939e5210 100644
--- a/Documentation/arm64/hugetlbpage.txt
+++ b/Documentation/arm64/hugetlbpage.rst
@@ -1,3 +1,4 @@
+====================
 HugeTLBpage on ARM64
 ====================
 
@@ -31,8 +32,10 @@ and level of the page table.
 
 The following hugepage sizes are supported -
 
-         CONT PTE    PMD    CONT PMD    PUD
-         --------    ---    --------    ---
+  ====== ========   ====    ========    ===
+  -      CONT PTE    PMD    CONT PMD    PUD
+  ====== ========   ====    ========    ===
   4K:         64K     2M         32M     1G
   16K:         2M    32M          1G
   64K:         2M   512M         16G
+  ====== ========   ====    ========    ===
diff --git a/Documentation/arm64/index.rst b/Documentation/arm64/index.rst
new file mode 100644
index 000000000000..018b7836ecb7
--- /dev/null
+++ b/Documentation/arm64/index.rst
@@ -0,0 +1,28 @@
+:orphan:
+
+==================
+ARM64 Architecture
+==================
+
+.. toctree::
+    :maxdepth: 1
+
+    acpi_object_usage
+    arm-acpi
+    booting
+    cpu-feature-registers
+    elf_hwcaps
+    hugetlbpage
+    legacy_instructions
+    memory
+    pointer-authentication
+    silicon-errata
+    sve
+    tagged-pointers
+
+.. only::  subproject and html
+
+   Indices
+   =======
+
+   * :ref:`genindex`
diff --git a/Documentation/arm64/legacy_instructions.txt b/Documentation/arm64/legacy_instructions.rst
similarity index 73%
rename from Documentation/arm64/legacy_instructions.txt
rename to Documentation/arm64/legacy_instructions.rst
index 01bf3d9fac85..54401b22cb8f 100644
--- a/Documentation/arm64/legacy_instructions.txt
+++ b/Documentation/arm64/legacy_instructions.rst
@@ -1,3 +1,7 @@
+===================
+Legacy instructions
+===================
+
 The arm64 port of the Linux kernel provides infrastructure to support
 emulation of instructions which have been deprecated, or obsoleted in
 the architecture. The infrastructure code uses undefined instruction
@@ -9,19 +13,22 @@ The emulation mode can be controlled by writing to sysctl nodes
 behaviours and the corresponding values of the sysctl nodes -
 
 * Undef
-  Value: 0
+    Value: 0
+
   Generates undefined instruction abort. Default for instructions that
   have been obsoleted in the architecture, e.g., SWP
 
 * Emulate
-  Value: 1
+    Value: 1
+
   Uses software emulation. To aid migration of software, in this mode
   usage of emulated instruction is traced as well as rate limited
   warnings are issued. This is the default for deprecated
   instructions, .e.g., CP15 barriers
 
 * Hardware Execution
-  Value: 2
+    Value: 2
+
   Although marked as deprecated, some implementations may support the
   enabling/disabling of hardware support for the execution of these
   instructions. Using hardware execution generally provides better
@@ -38,20 +45,24 @@ individual instruction notes for further information.
 Supported legacy instructions
 -----------------------------
 * SWP{B}
-Node: /proc/sys/abi/swp
-Status: Obsolete
-Default: Undef (0)
+
+:Node: /proc/sys/abi/swp
+:Status: Obsolete
+:Default: Undef (0)
 
 * CP15 Barriers
-Node: /proc/sys/abi/cp15_barrier
-Status: Deprecated
-Default: Emulate (1)
+
+:Node: /proc/sys/abi/cp15_barrier
+:Status: Deprecated
+:Default: Emulate (1)
 
 * SETEND
-Node: /proc/sys/abi/setend
-Status: Deprecated
-Default: Emulate (1)*
-Note: All the cpus on the system must have mixed endian support at EL0
-for this feature to be enabled. If a new CPU - which doesn't support mixed
-endian - is hotplugged in after this feature has been enabled, there could
-be unexpected results in the application.
+
+:Node: /proc/sys/abi/setend
+:Status: Deprecated
+:Default: Emulate (1)*
+
+  Note: All the cpus on the system must have mixed endian support at EL0
+  for this feature to be enabled. If a new CPU - which doesn't support mixed
+  endian - is hotplugged in after this feature has been enabled, there could
+  be unexpected results in the application.
diff --git a/Documentation/arm64/memory.rst b/Documentation/arm64/memory.rst
new file mode 100644
index 000000000000..464b880fc4b7
--- /dev/null
+++ b/Documentation/arm64/memory.rst
@@ -0,0 +1,98 @@
+==============================
+Memory Layout on AArch64 Linux
+==============================
+
+Author: Catalin Marinas <catalin.marinas@arm.com>
+
+This document describes the virtual memory layout used by the AArch64
+Linux kernel. The architecture allows up to 4 levels of translation
+tables with a 4KB page size and up to 3 levels with a 64KB page size.
+
+AArch64 Linux uses either 3 levels or 4 levels of translation tables
+with the 4KB page configuration, allowing 39-bit (512GB) or 48-bit
+(256TB) virtual addresses, respectively, for both user and kernel. With
+64KB pages, only 2 levels of translation tables, allowing 42-bit (4TB)
+virtual address, are used but the memory layout is the same.
+
+User addresses have bits 63:48 set to 0 while the kernel addresses have
+the same bits set to 1. TTBRx selection is given by bit 63 of the
+virtual address. The swapper_pg_dir contains only kernel (global)
+mappings while the user pgd contains only user (non-global) mappings.
+The swapper_pg_dir address is written to TTBR1 and never written to
+TTBR0.
+
+
+AArch64 Linux memory layout with 4KB pages + 3 levels::
+
+  Start			End			Size		Use
+  -----------------------------------------------------------------------
+  0000000000000000	0000007fffffffff	 512GB		user
+  ffffff8000000000	ffffffffffffffff	 512GB		kernel
+
+
+AArch64 Linux memory layout with 4KB pages + 4 levels::
+
+  Start			End			Size		Use
+  -----------------------------------------------------------------------
+  0000000000000000	0000ffffffffffff	 256TB		user
+  ffff000000000000	ffffffffffffffff	 256TB		kernel
+
+
+AArch64 Linux memory layout with 64KB pages + 2 levels::
+
+  Start			End			Size		Use
+  -----------------------------------------------------------------------
+  0000000000000000	000003ffffffffff	   4TB		user
+  fffffc0000000000	ffffffffffffffff	   4TB		kernel
+
+
+AArch64 Linux memory layout with 64KB pages + 3 levels::
+
+  Start			End			Size		Use
+  -----------------------------------------------------------------------
+  0000000000000000	0000ffffffffffff	 256TB		user
+  ffff000000000000	ffffffffffffffff	 256TB		kernel
+
+
+For details of the virtual kernel memory layout please see the kernel
+booting log.
+
+
+Translation table lookup with 4KB pages::
+
+  +--------+--------+--------+--------+--------+--------+--------+--------+
+  |63    56|55    48|47    40|39    32|31    24|23    16|15     8|7      0|
+  +--------+--------+--------+--------+--------+--------+--------+--------+
+   |                 |         |         |         |         |
+   |                 |         |         |         |         v
+   |                 |         |         |         |   [11:0]  in-page offset
+   |                 |         |         |         +-> [20:12] L3 index
+   |                 |         |         +-----------> [29:21] L2 index
+   |                 |         +---------------------> [38:30] L1 index
+   |                 +-------------------------------> [47:39] L0 index
+   +-------------------------------------------------> [63] TTBR0/1
+
+
+Translation table lookup with 64KB pages::
+
+  +--------+--------+--------+--------+--------+--------+--------+--------+
+  |63    56|55    48|47    40|39    32|31    24|23    16|15     8|7      0|
+  +--------+--------+--------+--------+--------+--------+--------+--------+
+   |                 |    |               |              |
+   |                 |    |               |              v
+   |                 |    |               |            [15:0]  in-page offset
+   |                 |    |               +----------> [28:16] L3 index
+   |                 |    +--------------------------> [41:29] L2 index
+   |                 +-------------------------------> [47:42] L1 index
+   +-------------------------------------------------> [63] TTBR0/1
+
+
+When using KVM without the Virtualization Host Extensions, the
+hypervisor maps kernel pages in EL2 at a fixed (and potentially
+random) offset from the linear mapping. See the kern_hyp_va macro and
+kvm_update_va_mask function for more details. MMIO devices such as
+GICv2 gets mapped next to the HYP idmap page, as do vectors when
+ARM64_HARDEN_EL2_VECTORS is selected for particular CPUs.
+
+When using KVM with the Virtualization Host Extensions, no additional
+mappings are created, since the host kernel runs directly in EL2.
diff --git a/Documentation/arm64/memory.txt b/Documentation/arm64/memory.txt
deleted file mode 100644
index c5dab30d3389..000000000000
--- a/Documentation/arm64/memory.txt
+++ /dev/null
@@ -1,97 +0,0 @@
-		     Memory Layout on AArch64 Linux
-		     ==============================
-
-Author: Catalin Marinas <catalin.marinas@arm.com>
-
-This document describes the virtual memory layout used by the AArch64
-Linux kernel. The architecture allows up to 4 levels of translation
-tables with a 4KB page size and up to 3 levels with a 64KB page size.
-
-AArch64 Linux uses either 3 levels or 4 levels of translation tables
-with the 4KB page configuration, allowing 39-bit (512GB) or 48-bit
-(256TB) virtual addresses, respectively, for both user and kernel. With
-64KB pages, only 2 levels of translation tables, allowing 42-bit (4TB)
-virtual address, are used but the memory layout is the same.
-
-User addresses have bits 63:48 set to 0 while the kernel addresses have
-the same bits set to 1. TTBRx selection is given by bit 63 of the
-virtual address. The swapper_pg_dir contains only kernel (global)
-mappings while the user pgd contains only user (non-global) mappings.
-The swapper_pg_dir address is written to TTBR1 and never written to
-TTBR0.
-
-
-AArch64 Linux memory layout with 4KB pages + 3 levels:
-
-Start			End			Size		Use
------------------------------------------------------------------------
-0000000000000000	0000007fffffffff	 512GB		user
-ffffff8000000000	ffffffffffffffff	 512GB		kernel
-
-
-AArch64 Linux memory layout with 4KB pages + 4 levels:
-
-Start			End			Size		Use
------------------------------------------------------------------------
-0000000000000000	0000ffffffffffff	 256TB		user
-ffff000000000000	ffffffffffffffff	 256TB		kernel
-
-
-AArch64 Linux memory layout with 64KB pages + 2 levels:
-
-Start			End			Size		Use
------------------------------------------------------------------------
-0000000000000000	000003ffffffffff	   4TB		user
-fffffc0000000000	ffffffffffffffff	   4TB		kernel
-
-
-AArch64 Linux memory layout with 64KB pages + 3 levels:
-
-Start			End			Size		Use
------------------------------------------------------------------------
-0000000000000000	0000ffffffffffff	 256TB		user
-ffff000000000000	ffffffffffffffff	 256TB		kernel
-
-
-For details of the virtual kernel memory layout please see the kernel
-booting log.
-
-
-Translation table lookup with 4KB pages:
-
-+--------+--------+--------+--------+--------+--------+--------+--------+
-|63    56|55    48|47    40|39    32|31    24|23    16|15     8|7      0|
-+--------+--------+--------+--------+--------+--------+--------+--------+
- |                 |         |         |         |         |
- |                 |         |         |         |         v
- |                 |         |         |         |   [11:0]  in-page offset
- |                 |         |         |         +-> [20:12] L3 index
- |                 |         |         +-----------> [29:21] L2 index
- |                 |         +---------------------> [38:30] L1 index
- |                 +-------------------------------> [47:39] L0 index
- +-------------------------------------------------> [63] TTBR0/1
-
-
-Translation table lookup with 64KB pages:
-
-+--------+--------+--------+--------+--------+--------+--------+--------+
-|63    56|55    48|47    40|39    32|31    24|23    16|15     8|7      0|
-+--------+--------+--------+--------+--------+--------+--------+--------+
- |                 |    |               |              |
- |                 |    |               |              v
- |                 |    |               |            [15:0]  in-page offset
- |                 |    |               +----------> [28:16] L3 index
- |                 |    +--------------------------> [41:29] L2 index
- |                 +-------------------------------> [47:42] L1 index
- +-------------------------------------------------> [63] TTBR0/1
-
-
-When using KVM without the Virtualization Host Extensions, the
-hypervisor maps kernel pages in EL2 at a fixed (and potentially
-random) offset from the linear mapping. See the kern_hyp_va macro and
-kvm_update_va_mask function for more details. MMIO devices such as
-GICv2 gets mapped next to the HYP idmap page, as do vectors when
-ARM64_HARDEN_EL2_VECTORS is selected for particular CPUs.
-
-When using KVM with the Virtualization Host Extensions, no additional
-mappings are created, since the host kernel runs directly in EL2.
diff --git a/Documentation/arm64/pointer-authentication.txt b/Documentation/arm64/pointer-authentication.rst
similarity index 99%
rename from Documentation/arm64/pointer-authentication.txt
rename to Documentation/arm64/pointer-authentication.rst
index fc71b33de87e..30b2ab06526b 100644
--- a/Documentation/arm64/pointer-authentication.txt
+++ b/Documentation/arm64/pointer-authentication.rst
@@ -1,7 +1,9 @@
+=======================================
 Pointer authentication in AArch64 Linux
 =======================================
 
 Author: Mark Rutland <mark.rutland@arm.com>
+
 Date: 2017-07-19
 
 This document briefly describes the provision of pointer authentication
diff --git a/Documentation/arm64/silicon-errata.txt b/Documentation/arm64/silicon-errata.rst
similarity index 55%
rename from Documentation/arm64/silicon-errata.txt
rename to Documentation/arm64/silicon-errata.rst
index 2735462d5958..c792774be59e 100644
--- a/Documentation/arm64/silicon-errata.txt
+++ b/Documentation/arm64/silicon-errata.rst
@@ -1,7 +1,9 @@
-                Silicon Errata and Software Workarounds
-                =======================================
+=======================================
+Silicon Errata and Software Workarounds
+=======================================
 
 Author: Will Deacon <will.deacon@arm.com>
+
 Date  : 27 November 2015
 
 It is an unfortunate fact of life that hardware is often produced with
@@ -9,11 +11,13 @@ so-called "errata", which can cause it to deviate from the architecture
 under specific circumstances.  For hardware produced by ARM, these
 errata are broadly classified into the following categories:
 
-  Category A: A critical error without a viable workaround.
-  Category B: A significant or critical error with an acceptable
+  ==========  ========================================================
+  Category A  A critical error without a viable workaround.
+  Category B  A significant or critical error with an acceptable
               workaround.
-  Category C: A minor error that is not expected to occur under normal
+  Category C  A minor error that is not expected to occur under normal
               operation.
+  ==========  ========================================================
 
 For more information, consult one of the "Software Developers Errata
 Notice" documents available on infocenter.arm.com (registration
@@ -42,47 +46,86 @@ file acts as a registry of software workarounds in the Linux Kernel and
 will be updated when new workarounds are committed and backported to
 stable kernels.
 
++----------------+-----------------+-----------------+-----------------------------+
 | Implementor    | Component       | Erratum ID      | Kconfig                     |
-+----------------+-----------------+-----------------+-----------------------------+
++================+=================+=================+=============================+
 | Allwinner      | A64/R18         | UNKNOWN1        | SUN50I_ERRATUM_UNKNOWN1     |
-|                |                 |                 |                             |
++----------------+-----------------+-----------------+-----------------------------+
++----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A53      | #826319         | ARM64_ERRATUM_826319        |
++----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A53      | #827319         | ARM64_ERRATUM_827319        |
++----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A53      | #824069         | ARM64_ERRATUM_824069        |
++----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A53      | #819472         | ARM64_ERRATUM_819472        |
++----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A53      | #845719         | ARM64_ERRATUM_845719        |
++----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A53      | #843419         | ARM64_ERRATUM_843419        |
++----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A57      | #832075         | ARM64_ERRATUM_832075        |
++----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A57      | #852523         | N/A                         |
++----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A57      | #834220         | ARM64_ERRATUM_834220        |
++----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A72      | #853709         | N/A                         |
++----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A73      | #858921         | ARM64_ERRATUM_858921        |
++----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A55      | #1024718        | ARM64_ERRATUM_1024718       |
++----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A76      | #1188873,1418040| ARM64_ERRATUM_1418040       |
++----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A76      | #1165522        | ARM64_ERRATUM_1165522       |
++----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A76      | #1286807        | ARM64_ERRATUM_1286807       |
++----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A76      | #1463225        | ARM64_ERRATUM_1463225       |
++----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Neoverse-N1     | #1188873,1418040| ARM64_ERRATUM_1418040       |
++----------------+-----------------+-----------------+-----------------------------+
 | ARM            | MMU-500         | #841119,826419  | N/A                         |
-|                |                 |                 |                             |
++----------------+-----------------+-----------------+-----------------------------+
++----------------+-----------------+-----------------+-----------------------------+
 | Cavium         | ThunderX ITS    | #22375,24313    | CAVIUM_ERRATUM_22375        |
++----------------+-----------------+-----------------+-----------------------------+
 | Cavium         | ThunderX ITS    | #23144          | CAVIUM_ERRATUM_23144        |
++----------------+-----------------+-----------------+-----------------------------+
 | Cavium         | ThunderX GICv3  | #23154          | CAVIUM_ERRATUM_23154        |
++----------------+-----------------+-----------------+-----------------------------+
 | Cavium         | ThunderX Core   | #27456          | CAVIUM_ERRATUM_27456        |
++----------------+-----------------+-----------------+-----------------------------+
 | Cavium         | ThunderX Core   | #30115          | CAVIUM_ERRATUM_30115        |
++----------------+-----------------+-----------------+-----------------------------+
 | Cavium         | ThunderX SMMUv2 | #27704          | N/A                         |
++----------------+-----------------+-----------------+-----------------------------+
 | Cavium         | ThunderX2 SMMUv3| #74             | N/A                         |
++----------------+-----------------+-----------------+-----------------------------+
 | Cavium         | ThunderX2 SMMUv3| #126            | N/A                         |
-|                |                 |                 |                             |
++----------------+-----------------+-----------------+-----------------------------+
++----------------+-----------------+-----------------+-----------------------------+
 | Freescale/NXP  | LS2080A/LS1043A | A-008585        | FSL_ERRATUM_A008585         |
-|                |                 |                 |                             |
++----------------+-----------------+-----------------+-----------------------------+
++----------------+-----------------+-----------------+-----------------------------+
 | Hisilicon      | Hip0{5,6,7}     | #161010101      | HISILICON_ERRATUM_161010101 |
++----------------+-----------------+-----------------+-----------------------------+
 | Hisilicon      | Hip0{6,7}       | #161010701      | N/A                         |
++----------------+-----------------+-----------------+-----------------------------+
 | Hisilicon      | Hip07           | #161600802      | HISILICON_ERRATUM_161600802 |
++----------------+-----------------+-----------------+-----------------------------+
 | Hisilicon      | Hip08 SMMU PMCG | #162001800      | N/A                         |
-|                |                 |                 |                             |
++----------------+-----------------+-----------------+-----------------------------+
++----------------+-----------------+-----------------+-----------------------------+
 | Qualcomm Tech. | Kryo/Falkor v1  | E1003           | QCOM_FALKOR_ERRATUM_1003    |
++----------------+-----------------+-----------------+-----------------------------+
 | Qualcomm Tech. | Falkor v1       | E1009           | QCOM_FALKOR_ERRATUM_1009    |
++----------------+-----------------+-----------------+-----------------------------+
 | Qualcomm Tech. | QDF2400 ITS     | E0065           | QCOM_QDF2400_ERRATUM_0065   |
++----------------+-----------------+-----------------+-----------------------------+
 | Qualcomm Tech. | Falkor v{1,2}   | E1041           | QCOM_FALKOR_ERRATUM_1041    |
++----------------+-----------------+-----------------+-----------------------------+
++----------------+-----------------+-----------------+-----------------------------+
 | Fujitsu        | A64FX           | E#010001        | FUJITSU_ERRATUM_010001      |
++----------------+-----------------+-----------------+-----------------------------+
diff --git a/Documentation/arm64/sve.txt b/Documentation/arm64/sve.rst
similarity index 98%
rename from Documentation/arm64/sve.txt
rename to Documentation/arm64/sve.rst
index 9940e924a47e..38422ab249dd 100644
--- a/Documentation/arm64/sve.txt
+++ b/Documentation/arm64/sve.rst
@@ -1,7 +1,9 @@
-            Scalable Vector Extension support for AArch64 Linux
-            ===================================================
+===================================================
+Scalable Vector Extension support for AArch64 Linux
+===================================================
 
 Author: Dave Martin <Dave.Martin@arm.com>
+
 Date:   4 August 2017
 
 This document outlines briefly the interface provided to userspace by Linux in
@@ -426,7 +428,7 @@ In A64 state, SVE adds the following:
 
 * FPSR and FPCR are retained from ARMv8-A, and interact with SVE floating-point
   operations in a similar way to the way in which they interact with ARMv8
-  floating-point operations.
+  floating-point operations::
 
          8VL-1                       128               0  bit index
         +----          ////            -----------------+
@@ -483,6 +485,8 @@ ARMv8-A defines the following floating-point / SIMD register state:
 * 32 128-bit vector registers V0..V31
 * 2 32-bit status/control registers FPSR, FPCR
 
+::
+
          127           0  bit index
         +---------------+
      V0 |               |
@@ -517,7 +521,7 @@ References
 [2] arch/arm64/include/uapi/asm/ptrace.h
     AArch64 Linux ptrace ABI definitions
 
-[3] Documentation/arm64/cpu-feature-registers.txt
+[3] Documentation/arm64/cpu-feature-registers.rst
 
 [4] ARM IHI0055C
     http://infocenter.arm.com/help/topic/com.arm.doc.ihi0055c/IHI0055C_beta_aapcs64.pdf
diff --git a/Documentation/arm64/tagged-pointers.txt b/Documentation/arm64/tagged-pointers.rst
similarity index 94%
rename from Documentation/arm64/tagged-pointers.txt
rename to Documentation/arm64/tagged-pointers.rst
index a25a99e82bb1..2acdec3ebbeb 100644
--- a/Documentation/arm64/tagged-pointers.txt
+++ b/Documentation/arm64/tagged-pointers.rst
@@ -1,7 +1,9 @@
-		Tagged virtual addresses in AArch64 Linux
-		=========================================
+=========================================
+Tagged virtual addresses in AArch64 Linux
+=========================================
 
 Author: Will Deacon <will.deacon@arm.com>
+
 Date  : 12 June 2013
 
 This document briefly describes the provision of tagged virtual
diff --git a/Documentation/translations/zh_CN/arm64/booting.txt b/Documentation/translations/zh_CN/arm64/booting.txt
index c1dd968c5ee9..3bfbf66e5a5e 100644
--- a/Documentation/translations/zh_CN/arm64/booting.txt
+++ b/Documentation/translations/zh_CN/arm64/booting.txt
@@ -1,4 +1,4 @@
-Chinese translated version of Documentation/arm64/booting.txt
+Chinese translated version of Documentation/arm64/booting.rst
 
 If you have any comment or update to the content, please contact the
 original document maintainer directly.  However, if you have a problem
@@ -10,7 +10,7 @@ M:	Will Deacon <will.deacon@arm.com>
 zh_CN:	Fu Wei <wefu@redhat.com>
 C:	55f058e7574c3615dea4615573a19bdb258696c6
 ---------------------------------------------------------------------
-Documentation/arm64/booting.txt 的中文翻译
+Documentation/arm64/booting.rst 的中文翻译
 
 如果想评论或更新本文的内容，请直接联系原文档的维护者。如果你使用英文
 交流有困难的话，也可以向中文版维护者求助。如果本翻译更新不及时或者翻
diff --git a/Documentation/translations/zh_CN/arm64/legacy_instructions.txt b/Documentation/translations/zh_CN/arm64/legacy_instructions.txt
index 68362a1ab717..e295cf75f606 100644
--- a/Documentation/translations/zh_CN/arm64/legacy_instructions.txt
+++ b/Documentation/translations/zh_CN/arm64/legacy_instructions.txt
@@ -1,4 +1,4 @@
-Chinese translated version of Documentation/arm64/legacy_instructions.txt
+Chinese translated version of Documentation/arm64/legacy_instructions.rst
 
 If you have any comment or update to the content, please contact the
 original document maintainer directly.  However, if you have a problem
@@ -10,7 +10,7 @@ Maintainer: Punit Agrawal <punit.agrawal@arm.com>
             Suzuki K. Poulose <suzuki.poulose@arm.com>
 Chinese maintainer: Fu Wei <wefu@redhat.com>
 ---------------------------------------------------------------------
-Documentation/arm64/legacy_instructions.txt 的中文翻译
+Documentation/arm64/legacy_instructions.rst 的中文翻译
 
 如果想评论或更新本文的内容，请直接联系原文档的维护者。如果你使用英文
 交流有困难的话，也可以向中文版维护者求助。如果本翻译更新不及时或者翻
diff --git a/Documentation/translations/zh_CN/arm64/memory.txt b/Documentation/translations/zh_CN/arm64/memory.txt
index 19b3a52d5d94..be20f8228b91 100644
--- a/Documentation/translations/zh_CN/arm64/memory.txt
+++ b/Documentation/translations/zh_CN/arm64/memory.txt
@@ -1,4 +1,4 @@
-Chinese translated version of Documentation/arm64/memory.txt
+Chinese translated version of Documentation/arm64/memory.rst
 
 If you have any comment or update to the content, please contact the
 original document maintainer directly.  However, if you have a problem
@@ -9,7 +9,7 @@ or if there is a problem with the translation.
 Maintainer: Catalin Marinas <catalin.marinas@arm.com>
 Chinese maintainer: Fu Wei <wefu@redhat.com>
 ---------------------------------------------------------------------
-Documentation/arm64/memory.txt 的中文翻译
+Documentation/arm64/memory.rst 的中文翻译
 
 如果想评论或更新本文的内容，请直接联系原文档的维护者。如果你使用英文
 交流有困难的话，也可以向中文版维护者求助。如果本翻译更新不及时或者翻
diff --git a/Documentation/translations/zh_CN/arm64/silicon-errata.txt b/Documentation/translations/zh_CN/arm64/silicon-errata.txt
index 39477c75c4a4..440c59ac7dce 100644
--- a/Documentation/translations/zh_CN/arm64/silicon-errata.txt
+++ b/Documentation/translations/zh_CN/arm64/silicon-errata.txt
@@ -1,4 +1,4 @@
-Chinese translated version of Documentation/arm64/silicon-errata.txt
+Chinese translated version of Documentation/arm64/silicon-errata.rst
 
 If you have any comment or update to the content, please contact the
 original document maintainer directly.  However, if you have a problem
@@ -10,7 +10,7 @@ M:	Will Deacon <will.deacon@arm.com>
 zh_CN:	Fu Wei <wefu@redhat.com>
 C:	1926e54f115725a9248d0c4c65c22acaf94de4c4
 ---------------------------------------------------------------------
-Documentation/arm64/silicon-errata.txt 的中文翻译
+Documentation/arm64/silicon-errata.rst 的中文翻译
 
 如果想评论或更新本文的内容，请直接联系原文档的维护者。如果你使用英文
 交流有困难的话，也可以向中文版维护者求助。如果本翻译更新不及时或者翻
diff --git a/Documentation/translations/zh_CN/arm64/tagged-pointers.txt b/Documentation/translations/zh_CN/arm64/tagged-pointers.txt
index 2664d1bd5a1c..77ac3548a16d 100644
--- a/Documentation/translations/zh_CN/arm64/tagged-pointers.txt
+++ b/Documentation/translations/zh_CN/arm64/tagged-pointers.txt
@@ -1,4 +1,4 @@
-Chinese translated version of Documentation/arm64/tagged-pointers.txt
+Chinese translated version of Documentation/arm64/tagged-pointers.rst
 
 If you have any comment or update to the content, please contact the
 original document maintainer directly.  However, if you have a problem
@@ -9,7 +9,7 @@ or if there is a problem with the translation.
 Maintainer: Will Deacon <will.deacon@arm.com>
 Chinese maintainer: Fu Wei <wefu@redhat.com>
 ---------------------------------------------------------------------
-Documentation/arm64/tagged-pointers.txt 的中文翻译
+Documentation/arm64/tagged-pointers.rst 的中文翻译
 
 如果想评论或更新本文的内容，请直接联系原文档的维护者。如果你使用英文
 交流有困难的话，也可以向中文版维护者求助。如果本翻译更新不及时或者翻
diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index ba6c42c576dd..68984c284c40 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -2205,7 +2205,7 @@ max_vq.  This is the maximum vector length available to the guest on
 this vcpu, and determines which register slices are visible through
 this ioctl interface.
 
-(See Documentation/arm64/sve.txt for an explanation of the "vq"
+(See Documentation/arm64/sve.rst for an explanation of the "vq"
 nomenclature.)
 
 KVM_REG_ARM64_SVE_VLS is only accessible after KVM_ARM_VCPU_INIT.
diff --git a/arch/arm64/include/asm/efi.h b/arch/arm64/include/asm/efi.h
index c9e9a6978e73..8e79ce9c3f5c 100644
--- a/arch/arm64/include/asm/efi.h
+++ b/arch/arm64/include/asm/efi.h
@@ -83,7 +83,7 @@ static inline unsigned long efi_get_max_fdt_addr(unsigned long dram_base)
  * guaranteed to cover the kernel Image.
  *
  * Since the EFI stub is part of the kernel Image, we can relax the
- * usual requirements in Documentation/arm64/booting.txt, which still
+ * usual requirements in Documentation/arm64/booting.rst, which still
  * apply to other bootloaders, and are required for some kernel
  * configurations.
  */
diff --git a/arch/arm64/include/asm/image.h b/arch/arm64/include/asm/image.h
index e2c27a2278e9..c2b13213c720 100644
--- a/arch/arm64/include/asm/image.h
+++ b/arch/arm64/include/asm/image.h
@@ -27,7 +27,7 @@
 
 /*
  * struct arm64_image_header - arm64 kernel image header
- * See Documentation/arm64/booting.txt for details
+ * See Documentation/arm64/booting.rst for details
  *
  * @code0:		Executable code, or
  *   @mz_header		  alternatively used for part of MZ header
diff --git a/arch/arm64/include/uapi/asm/sigcontext.h b/arch/arm64/include/uapi/asm/sigcontext.h
index 5f3c0cec5af9..a61f89ddbf34 100644
--- a/arch/arm64/include/uapi/asm/sigcontext.h
+++ b/arch/arm64/include/uapi/asm/sigcontext.h
@@ -137,7 +137,7 @@ struct sve_context {
  * vector length beyond its initial architectural limit of 2048 bits
  * (16 quadwords).
  *
- * See linux/Documentation/arm64/sve.txt for a description of the VL/VQ
+ * See linux/Documentation/arm64/sve.rst for a description of the VL/VQ
  * terminology.
  */
 #define SVE_VQ_BYTES		__SVE_VQ_BYTES	/* bytes per quadword */
diff --git a/arch/arm64/kernel/kexec_image.c b/arch/arm64/kernel/kexec_image.c
index 31cc2f423aa8..2514fd6f12cb 100644
--- a/arch/arm64/kernel/kexec_image.c
+++ b/arch/arm64/kernel/kexec_image.c
@@ -53,7 +53,7 @@ static void *image_load(struct kimage *image,
 
 	/*
 	 * We require a kernel with an unambiguous Image header. Per
-	 * Documentation/arm64/booting.txt, this is the case when image_size
+	 * Documentation/arm64/booting.rst, this is the case when image_size
 	 * is non-zero (practically speaking, since v3.17).
 	 */
 	h = (struct arm64_image_header *)kernel;
-- 
2.21.0

