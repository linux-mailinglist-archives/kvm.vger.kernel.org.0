Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 952F654F3C5
	for <lists+kvm@lfdr.de>; Fri, 17 Jun 2022 11:02:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235131AbiFQJC0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jun 2022 05:02:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232062AbiFQJCZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jun 2022 05:02:25 -0400
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BA48393CD;
        Fri, 17 Jun 2022 02:02:22 -0700 (PDT)
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id EBA0379E; Fri, 17 Jun 2022 11:02:19 +0200 (CEST)
Date:   Fri, 17 Jun 2022 11:02:14 +0200
From:   =?iso-8859-1?Q?J=F6rg_R=F6del?= <joro@8bytes.org>
To:     linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-pci@vger.kernel.org, iommu@lists.linux.dev,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Arnd Bergmann <arnd@kernel.org>,
        Ashok Raj <ashok.raj@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Bjorn Helgaas <helgaas@kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Joerg Roedel <joro@8bytes.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        Baolu Lu <baolu.lu@linux.intel.com>,
        Marc Zyngier <maz@kernel.org>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vasant Hegde <vasant.hegde@amd.com>,
        Will Deacon <will@kernel.org>
Subject: [CFP LPC 2022] VFIO/IOMMU/PCI Microconference
Message-ID: <YqxDFkAFdLjqnW8O@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello everyone!

We are pleased to announce that there will be another

	VFIO/IOMMU/PCI Microconference

at this year's Linux Plumbers Conference (LPC), from 12th to the 14th of
September in Dublin, Ireland. LPC is a hybrid event this year;
attendance can be in person or remote.

In this microconference we want to discuss ongoing developments around
the VFIO, IOMMU and PCI subsystems and their interactions in Linux.

Tentative topics that are under consideration for this year include (but
not limited to):

	* PCI:
	  - Cache Coherent Interconnect for Accelerators (CCIX)/Compute
	    Express Link (CXL) expansion memory and accelerators
	    management
	  - Data Object Exchange (DOE)
	  - Integrity and Data Encryption (IDE)
	  - Component Measurement and Authentication (CMA)
	  - Security Protocol and Data Model (SPDM)
	  - I/O Address Space ID Allocator (IOASID)
	  - INTX/MSI IRQ domain consolidation
	  - Gen-Z interconnect fabric
	  - ARM64 architecture and hardware
	  - PCI native host controllers/endpoints drivers current
	    challenges and improvements (e.g., state of PCI quirks, etc.)
	  - PCI error handling and management e.g., Advanced Error
	    Reporting (AER), Downstream Port Containment (DPC), ACPI
	    Platform Error Interface (APEI) and Error Disconnect Recover
	    (EDR)
	  - Power management and devices supporting Active-state Power
	    Management (ASPM)
	  - Peer-to-Peer DMA (P2PDMA)
	  - Resources claiming/assignment consolidation
	  - Probing of native PCIe controllers and general reset
	    implementation
	  - Prefetchable vs non-prefetchable BAR address mappings
	  - Untrusted/external devices management
	  - DMA ownership models
	  - Thunderbolt, DMA, RDMA and USB4 security

	* VFIO:
	  - Write-combine on non-x86 architectures
	  - I/O Page Fault (IOPF) for passthrough devices
	  - Shared Virtual Addressing (SVA) interface
	  - Single-root I/O Virtualization(SRIOV)/Process Address Space
	    ID (PASID) integration
	  - PASID in SRIOV virtual functions
	  - Device assignment/sub-assignment

	* IOMMU:
	  - /dev/iommufd development
	  - IOMMU virtualization
	  - IOMMU drivers SVA interface
	  - DMA-API layer interactions and the move towards generic
	    dma-ops for IOMMU drivers
	  - Possible IOMMU core changes (e.g., better integration with
	    device-driver core, etc.)

Please submit your proposals on the LPC website at:

	https://lpc.events/event/16/abstracts/

Make sure to select the "VFIO/IOMMU/PCI MC" in the Track pulldown
menu.

Looking forward to seeing you all there, either in Dublin or virtual! :)

The organizers,

	Alex Williamson
	Bjorn Helgaas
	Jörg Rödel
	Lorenzo Pieralisi
	Krzysztof Wilczyński

