Return-Path: <kvm+bounces-5342-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 38F60820720
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 17:21:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B75561F2137B
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 16:21:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E6C7BE4B;
	Sat, 30 Dec 2023 16:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ZpYJF7fF"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2076.outbound.protection.outlook.com [40.107.243.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BAC1BE5E;
	Sat, 30 Dec 2023 16:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mrioVGssFbsYcaupaFCQD0YLmchS+LUCw9HWu4O7Kh1nDjU1Qss5fqJsSmvfr2DEXTlNcv0Zf1vLapqnMnov4SNODhyGQPHre3nd13S3Zp385okRanG5xBoiFWZZO7fFkN4tlR0FVGjCM90wirXSKsk8hFtaCdyxoiYektcDgdxs6eG60PYgqVI7UJf9PwHWgxpvu9bVVqbU6qWVrcxkAe7gOcy7e3xtonrlYZ47ZUu+04bQKhTuLsc8yWCmhakVM5nyIMmHjVwVNwvN7P9x/+luzWlk3xHvIeZoQG5z48uFLAevZUVocX7/XAZ6VpAWPa1XD7EUwgmM8R02fAP7CQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X7abPHumm18y06mL52tBqOgOI2cb2Tchln9cQGzSgh4=;
 b=a4aL+S+p1FC4jWVVX0xa4Ou6ec+BwKverLdo/wRtEkqMCJZH2MNYD+R3o83wQ8ey/LUF/I/hgyMCQ0ZPQncWcmJTla0fsp/DodBIQADz9gfEGL75qesSVRRgrt73hf5yhUR+i9Q+VORo9SOYJ4QINCh3PO9K7PxaU4jq0Ll7Hkr0bfFW1UlrChnIDHAkuipLr8Spok5pGukR5WzGJqtt2v5qggqC2WB4VL056eLQq+3yasrxbm0khHgvn5VskcafSIxufErNy7X3mMx50zxfGuFtbu01X8G5Qdc1l2YgTaGrDAFrdhW1I+Y4dkCag5Xne4hlFsKODwwztsUutrv2Ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=alien8.de smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X7abPHumm18y06mL52tBqOgOI2cb2Tchln9cQGzSgh4=;
 b=ZpYJF7fF0Auc78lrPCWp1Rkw2tLyv0lDa2OEz7Cmtlv00GZ6KOAMWc7yizWozGDCbVhnZ0Y9Q+WQ4jyKndBT2/ZQECB17VSeAzepSCO4DaN5xc5ubG30SsqdhULCTj2ozpWPpbCGC6n/8E63u2XoDPj2rpaTyyyFMtD0gFSKkAQ=
Received: from CH2PR11CA0009.namprd11.prod.outlook.com (2603:10b6:610:54::19)
 by BN9PR12MB5273.namprd12.prod.outlook.com (2603:10b6:408:11e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.23; Sat, 30 Dec
 2023 16:21:05 +0000
Received: from DS3PEPF000099DE.namprd04.prod.outlook.com
 (2603:10b6:610:54:cafe::ba) by CH2PR11CA0009.outlook.office365.com
 (2603:10b6:610:54::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.21 via Frontend
 Transport; Sat, 30 Dec 2023 16:21:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF000099DE.mail.protection.outlook.com (10.167.17.200) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7159.9 via Frontend Transport; Sat, 30 Dec 2023 16:21:04 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Sat, 30 Dec
 2023 10:21:04 -0600
Date: Fri, 29 Dec 2023 15:38:28 -0600
From: Michael Roth <michael.roth@amd.com>
To: Borislav Petkov <bp@alien8.de>
CC: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <hpa@zytor.com>,
	<ardb@kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<vkuznets@redhat.com>, <jmattson@google.com>, <luto@kernel.org>,
	<dave.hansen@linux.intel.com>, <slp@redhat.com>, <pgonda@google.com>,
	<peterz@infradead.org>, <srinivas.pandruvada@linux.intel.com>,
	<rientjes@google.com>, <dovmurik@linux.ibm.com>, <tobin@ibm.com>,
	<vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
	<tony.luck@intel.com>, <marcorr@google.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>,
	Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH v10 18/50] crypto: ccp: Handle the legacy SEV command
 when SNP is enabled
Message-ID: <20231229213828.x6zivjikri5qfa5e@amd.com>
References: <20231016132819.1002933-1-michael.roth@amd.com>
 <20231016132819.1002933-19-michael.roth@amd.com>
 <20231209153656.GGZXSJmNAyMUT+qIpQ@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20231209153656.GGZXSJmNAyMUT+qIpQ@fat_crate.local>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF000099DE:EE_|BN9PR12MB5273:EE_
X-MS-Office365-Filtering-Correlation-Id: 1082e1f0-6b9c-4061-2791-08dc09535263
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	v5ekBm/OWn6KHg4EBbWCW9/s6fgCmYMBkK45HdHzzAJvJ4wqITDZVFyRL4Cffk4lPAhMr3RKstphPgJs6VhQ/sE4r3A75LJRLhB9Icnk65F9zlfzBtU/X6jkyMsTC9sNCxkldS4EJ2pdh67yxS2e9z2FkyJTDJpD7iDR+fYH2L509UesGFmeAEiAFhmrLAh/RhUGNftgsfb7PHB7AzbvDocV1O+VLthuT9C2DU/DBr3kPpr+eW8qvKdDGhdmE+KovEGroMoTx/l171VO8cdNwQNp+RfMzF8AM+7pNQrAet7qOXLQheTBY5OUknNGAObLiuBQRnuik4NyCFjXnZC7p6a2HFJg8vIEMQm5z4b8MSdt+Gj9c7WLsed7aUhS6C02NNYHClB+315zRgPyT0jH3oVn157FuW/ubzN7qtwk/9p9r8XnQH3xdiS8v7KUz0uWcbsfnXrZhXwoKt5y4c9usBOfPq86U2rxRc0lojc/FkcFQtSRuYRLpHG+SOWtZDAnQMpYo+lhZmbjM96WjSw6LHxoA0ZW0y4PdG16g5ZALoq2Av3W7rud6OT+GslkZ05Qk9dacBUkgd/rwsu6VfAQhBXojfw4yjVZ9snDD9vT/LOiPmglQIpLet78r2aoA8Jg/YMpvQBmTx4XW2PvdUDGA8xj2dLpTFPye/s5kfuEe8hwvMkbY6NKssVyXJGX8i/+OyKeV7cS2CQrdG1kNxbxnjJ8bqvBGoqubwMV5tkEbsZ7a+QqYi868o+L3lqlDfxcDGAEQqriT2cXbHUjG6VKQw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(376002)(136003)(39860400002)(396003)(346002)(230922051799003)(186009)(82310400011)(451199024)(64100799003)(1800799012)(46966006)(36840700001)(40470700004)(2906002)(7406005)(7416002)(5660300002)(41300700001)(16526019)(40480700001)(83380400001)(426003)(40460700003)(2616005)(336012)(1076003)(26005)(47076005)(966005)(478600001)(6666004)(86362001)(81166007)(82740400003)(36860700001)(356005)(70586007)(70206006)(6916009)(54906003)(316002)(4326008)(44832011)(8676002)(8936002)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2023 16:21:04.8151
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1082e1f0-6b9c-4061-2791-08dc09535263
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099DE.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5273

On Sat, Dec 09, 2023 at 04:36:56PM +0100, Borislav Petkov wrote:
> > +static int __snp_cmd_buf_copy(int cmd, void *cmd_buf, bool to_fw, int fw_err)
> > +{
> > +	int (*func)(u64 *paddr, u32 len, bool guest, struct snp_host_map *map);
> > +	struct sev_device *sev = psp_master->sev_data;
> > +	bool from_fw = !to_fw;
> > +
> > +	/*
> > +	 * After the command is completed, change the command buffer memory to
> > +	 * hypervisor state.
> > +	 *
> > +	 * The immutable bit is automatically cleared by the firmware, so
> > +	 * no not need to reclaim the page.
> > +	 */
> > +	if (from_fw && sev_legacy_cmd_buf_writable(cmd)) {
> > +		if (snp_reclaim_pages(__pa(cmd_buf), 1, true))
> > +			return -EFAULT;
> > +
> > +		/* No need to go further if firmware failed to execute command. */
> > +		if (fw_err)
> > +			return 0;
> > +	}
> > +
> > +	if (to_fw)
> > +		func = map_firmware_writeable;
> > +	else
> > +		func = unmap_firmware_writeable;
> 
> Eww, ugly and with the macro above even worse. And completely
> unnecessary.
> 
> Define prep_buffer() as a normal function which selects which @func to
> call and then does it. Not like this.

I've rewritten this using a descriptor array to handle buffers for
various command parameters, and switched to allocating bounce buffers
on-demand to avoid some of the init/cleanup coordination. I dont think
any of these are really performance critical and its only for legacy
support, but would be straightforward to add a cache of pre-allocated
buffers later if needed.

I've tried to document/name the helpers so the flow is a bit clearer.

-Mike

> 
> ...
> 
> > +static inline bool need_firmware_copy(int cmd)
> > +{
> > +	struct sev_device *sev = psp_master->sev_data;
> > +
> > +	/* After SNP is INIT'ed, the behavior of legacy SEV command is changed. */
> 
> "initialized"
> 
> > +	return ((cmd < SEV_CMD_SNP_INIT) && sev->snp_initialized) ? true : false;
> 
> redundant ternary conditional:
> 
> 	return cmd < SEV_CMD_SNP_INIT && sev->snp_initialized;
> 
> > +}
> > +
> > +static int snp_aware_copy_to_firmware(int cmd, void *data)
> 
> What does "SNP aware" even mean?
> 
> > +{
> > +	return __snp_cmd_buf_copy(cmd, data, true, 0);
> > +}
> > +
> > +static int snp_aware_copy_from_firmware(int cmd, void *data, int fw_err)
> > +{
> > +	return __snp_cmd_buf_copy(cmd, data, false, fw_err);
> > +}
> > +
> >  static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
> >  {
> >  	struct psp_device *psp = psp_master;
> >  	struct sev_device *sev;
> >  	unsigned int phys_lsb, phys_msb;
> >  	unsigned int reg, ret = 0;
> > +	void *cmd_buf;
> >  	int buf_len;
> >  
> >  	if (!psp || !psp->sev_data)
> > @@ -487,12 +770,28 @@ static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
> >  	 * work for some memory, e.g. vmalloc'd addresses, and @data may not be
> >  	 * physically contiguous.
> >  	 */
> > -	if (data)
> > -		memcpy(sev->cmd_buf, data, buf_len);
> > +	if (data) {
> > +		if (sev->cmd_buf_active > 2)
> 
> What is that silly counter supposed to mean?
> 
> Nested SNP commands?
> 
> > +			return -EBUSY;
> > +
> > +		cmd_buf = sev->cmd_buf_active ? sev->cmd_buf_backup : sev->cmd_buf;
> > +
> > +		memcpy(cmd_buf, data, buf_len);
> > +		sev->cmd_buf_active++;
> > +
> > +		/*
> > +		 * The behavior of the SEV-legacy commands is altered when the
> > +		 * SNP firmware is in the INIT state.
> > +		 */
> > +		if (need_firmware_copy(cmd) && snp_aware_copy_to_firmware(cmd, cmd_buf))
> 
> Move that need_firmware_copy() check inside snp_aware_copy_to_firmware()
> and the other one.
> 
> > +			return -EFAULT;
> > +	} else {
> > +		cmd_buf = sev->cmd_buf;
> > +	}
> >  
> >  	/* Get the physical address of the command buffer */
> > -	phys_lsb = data ? lower_32_bits(__psp_pa(sev->cmd_buf)) : 0;
> > -	phys_msb = data ? upper_32_bits(__psp_pa(sev->cmd_buf)) : 0;
> > +	phys_lsb = data ? lower_32_bits(__psp_pa(cmd_buf)) : 0;
> > +	phys_msb = data ? upper_32_bits(__psp_pa(cmd_buf)) : 0;
> >  
> >  	dev_dbg(sev->dev, "sev command id %#x buffer 0x%08x%08x timeout %us\n",
> >  		cmd, phys_msb, phys_lsb, psp_timeout);
> 
> ...
> 
> > @@ -639,6 +947,14 @@ static int ___sev_platform_init_locked(int *error, bool probe)
> >  	if (probe && !psp_init_on_probe)
> >  		return 0;
> >  
> > +	/*
> > +	 * Allocate the intermediate buffers used for the legacy command handling.
> > +	 */
> > +	if (rc != -ENODEV && alloc_snp_host_map(sev)) {
> 
> Why isn't this
> 
> 	if (!rc && ...)
> 
> > +		dev_notice(sev->dev, "Failed to alloc host map (disabling legacy SEV)\n");
> > +		goto skip_legacy;
> 
> No need for that skip_legacy silly label. Just "return 0" here.
> 
> ...
> 
> Thx.
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette
> 

