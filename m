Return-Path: <kvm+bounces-26269-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B1C2A973912
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 15:49:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2AD8A1F26193
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 13:49:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5323D194080;
	Tue, 10 Sep 2024 13:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jdo4DX90"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CA54192B9C;
	Tue, 10 Sep 2024 13:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725976160; cv=none; b=ZDUu/IzlE3mv4GQQsXFyM9NRZ/l5B+IAevfZ2Q3Qhy7v5wMcfj7wdbH2q0yPMwvV2aCKzyPfUxcu1x1f/fle80oa1MFzMNSdA21VqUBnXMupMmD11A4vjQtBo2a9yLXQgIKS1NtIVri/Au40rGo44sGbKIOgYOffEN+sqlqaxKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725976160; c=relaxed/simple;
	bh=fw/M42pCfVAc0YLnpR3ek5zD+pVyEqrE+OE+mrVQuH8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=nFL7zHqblMnpJYUV1LkqvWm9+ynj4G9qMgFLbMXgcve97p9gPcocZfnCcq5EHGIso9u8XqZyox4HcBfAV0nsPVqVmRirjOvkX8eBWpbeltm+vL2qy1qVu47nKn0T71yoJW3647QgfbTan8IuNQUGt66VoGWSfiXs4fVwZAA9hLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jdo4DX90; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1497C4CEC3;
	Tue, 10 Sep 2024 13:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725976160;
	bh=fw/M42pCfVAc0YLnpR3ek5zD+pVyEqrE+OE+mrVQuH8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=Jdo4DX90Z0vmjWge0UXVXxfYTAw/WA45saY7+tOkt4/8STo5zOGzY87KoSq9pXSxt
	 aoZ2fCClY6mrDIVY4qo9SHr7Sl/0m7U84GQhFESVVE83w1/zsZ//TRVchkVpXDUN/r
	 wztUAut2OJrUOVynOqtlvG6G8z1gOoM0CnWcDykkx2yUdsfdFUBQHuA8wRaRz210P2
	 TZGHI6pK2ul1FPqZYs+GUMlvDUKYXKABU+hsVY4mSgkrL2WjGetB1E0cOHlgtjHS6V
	 A7NKSruUupyn2GWzgvSXMVgfHzkOxrl/WpErkGYIlVrGZRocTSMAOBSjqwgg2QxbcE
	 68XmiPQgcRE/Q==
Date: Tue, 10 Sep 2024 08:49:18 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: zdravko delineshev <delineshev@outlook.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org
Subject: Re: nointxmask device
Message-ID: <20240910134918.GA579571@bhelgaas>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <VI1PR10MB8207C507DB5420AB4C7281E0DB9A2@VI1PR10MB8207.EURPRD10.PROD.OUTLOOK.COM>

[+cc Alex, kvm]

On Tue, Sep 10, 2024 at 01:13:41PM +0000, zdravko delineshev wrote:
> 
> Hello,
> 
> i found a note in the vfio-pci parameters to email devices fixed by the nointxmask parameter.
> 
> Here is the one i have and i am trying to pass trough. it is currently working fine, with nointxmask=1 .
> 
> 
> 81:00.0 Audio device: Creative Labs EMU20k2 [Sound Blaster X-Fi Titanium Series] (rev 03)
>         Subsystem: Creative Labs EMU20k2 [Sound Blaster X-Fi Titanium Series]
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B- DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0, Cache Line Size: 32 bytes
>         Interrupt: pin A routed to IRQ 409
>         NUMA node: 1
>         IOMMU group: 23
>         Region 0: Memory at d3200000 (64-bit, non-prefetchable) [size=64K]
>         Region 2: Memory at d3000000 (64-bit, non-prefetchable) [size=2M]
>         Region 4: Memory at d2000000 (64-bit, non-prefetchable) [size=16M]
>         Capabilities: [40] Power Management version 3
>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>         Capabilities: [48] MSI: Enable- Count=1/1 Maskable- 64bit+
>                 Address: 0000000000000000  Data: 0000
>         Capabilities: [58] Express (v2) Endpoint, MSI 00
>                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
>                         ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset- SlotPowerLimit 0W
>                 DevCtl: CorrErr- NonFatalErr- FatalErr+ UnsupReq-
>                         RlxdOrd+ ExtTag- PhantFunc- AuxPwr+ NoSnoop+
>                         MaxPayload 128 bytes, MaxReadReq 512 bytes
>                 DevSta: CorrErr- NonFatalErr- FatalErr- UnsupReq- AuxPwr- TransPend-
>                 LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit Latency L0s <64ns, L1 <1us
>                         ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp-
>                 LnkCtl: ASPM Disabled; RCB 64 bytes, Disabled- CommClk-
>                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                 LnkSta: Speed 2.5GT/s, Width x1
>                         TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
>                 DevCap2: Completion Timeout: Range ABCD, TimeoutDis- NROPrPrP- LTR-
>                          10BitTagComp- 10BitTagReq- OBFF Not Supported, ExtFmt- EETLPPrefix-
>                          EmergencyPowerReduction Not Supported, EmergencyPowerReductionInit-
>                          FRS- TPHComp- ExtTPHComp-
>                          AtomicOpsCap: 32bit- 64bit- 128bitCAS-
>                 DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis- LTR- 10BitTagReq- OBFF Disabled,
>                          AtomicOpsCtl: ReqEn-
>                 LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
>                          Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
>                          Compliance Preset/De-emphasis: -6dB de-emphasis, 0dB preshoot
>                 LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete- EqualizationPhase1-
>                          EqualizationPhase2- EqualizationPhase3- LinkEqualizationRequest-
>                          Retimer- 2Retimers- CrosslinkRes: unsupported
>         Capabilities: [100 v1] Device Serial Number ff-ff-ff-ff-ff-ff-ff-ff
>         Capabilities: [300 v1] Advanced Error Reporting
>                 UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
>                 UEMsk:  DLP- SDES+ TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
>                 UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
>                 CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr+
>                 CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr+
>                 AERCap: First Error Pointer: 00, ECRCGenCap+ ECRCGenEn- ECRCChkCap+ ECRCChkEn-
>                         MultHdrRecCap- MultHdrRecEn- TLPPfxPres- HdrLogCap-
>                 HeaderLog: 00000000 00000000 00000000 00000000
>         Kernel driver in use: vfio-pci
>         Kernel modules: snd_ctxfi
> 00: 02 11 0b 00 46 01 10 00 03 00 03 04 08 00 00 00
> 10: 04 00 20 d3 00 00 00 00 04 00 00 d3 00 00 00 00
> 20: 04 00 00 d2 00 00 00 00 00 00 00 00 02 11 44 00
> 30: 00 00 00 00 40 00 00 00 00 00 00 00 0b 01 00 00
> 40: 01 48 03 00 00 00 00 00 05 58 80 00 00 00 00 00
> 50: 00 00 00 00 00 00 00 00 10 00 02 00 00 80 00 00
> 60: 14 2c 20 00 11 0c 00 00 00 00 11 00 00 00 00 00
> 70: 00 00 00 00 00 00 00 00 00 00 00 00 0f 00 00 00
> 80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

