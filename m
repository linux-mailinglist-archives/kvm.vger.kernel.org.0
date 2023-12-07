Return-Path: <kvm+bounces-3862-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C9A7D808AF3
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 15:46:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E2A641C20C0F
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 14:46:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AFFF433BB;
	Thu,  7 Dec 2023 14:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="DCC8NxXV"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2085.outbound.protection.outlook.com [40.107.220.85])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EF68A3;
	Thu,  7 Dec 2023 06:46:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nw7NJdudbsItaN62qYBFzd/frVcUdrc0RSOyv+Ulbca8c/HBYVGOAyetdMBl8fI2Rk2bo5g8byeBWRU+Zch4HhsnMMO++KTMcyOQJLsJ1lk7ilERM4qC1DlawokeeHfIYs5m7zxrOt9i0AaePxyayUJ2CYY9/UupORrbrq36vIN9Tw4Y5OchCiYkn1XL6hkDEIkFLn7QBYZLzYYmgzm263oHtO8eW9oHMSa4rYzEiNRbNXMaNTXCZ4zmRsQNyn3X/erB/N5GhmtWmbwnYLNTSX5ygNMIHllNr8I7qPhhFp9V3mqwTNWKdileuH1TyCwTpBLDXdtggoiqg1AzUhuO3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DpiMwPjcLM6//nRsF0H6j5hXIB2lyukRBfOHt8bNGzg=;
 b=WpkyqoTxlMVxTDd9//kP3ejeDpS/s4tmm8zAn+5uws1Fugi+OStG36GnKsRhcxO5tQtm4h9vMlO/OHCIvEL7m9UNPlPyZFmqkMUbHmVZztiOqWy5qm51/6Syl5JSrx/6FMZB6AGRgy4qzZnAHtdwdEOP0ZtzvC+P4hduPyocwKVLonftatD+sNznb5LnGzXjrdI3Bv7qJpU/S6gHWNUyingJzJxUKalxSgmigw5EUIfdvKew9IN0y0IQ1ncHMjd6rTFfwiCXErZxHL1hww7Yi0GhW9DYUWqLiVnevTv/otFG9GJd3riZ8M0LfZf+1BMtCplUrYgawFSmraZHQlFLBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DpiMwPjcLM6//nRsF0H6j5hXIB2lyukRBfOHt8bNGzg=;
 b=DCC8NxXVlUGzi4FiqfcDoQUhl0u+bthwxvB+mNJtaZIWR2E+LfpjKp3dL/UAytH/dKYL133H+YP/Jy/9pmHTAIap+5r2kH4k8dOf87dzysiNbIyyawORwhY6QEA0Te5CZj1WBR0FsiKbdFwS9AsU7tqb2NMFif/Y9Cser/P/R8wAsRtOPuHDcyZL7ZVYZZqfKXhuvGhvZOjdG1gbzxkhYkMCSDdR1MgSm7EB0nC83xX47Pd+AJoLqanU78oVHDte54Ezr9iA6qlrsy0bh31XhIKVaav/7nhpcXB7yywdYLCPgfgGfW2CNg4OLKztF9p5whYD+U8uKk6wQgNG5Bph2g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DS7PR12MB5863.namprd12.prod.outlook.com (2603:10b6:8:7a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Thu, 7 Dec
 2023 14:46:15 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.038; Thu, 7 Dec 2023
 14:46:15 +0000
Date: Thu, 7 Dec 2023 10:46:15 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: "Cao, Yahui" <yahui.cao@intel.com>,
	"intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"Liu, Lingyu" <lingyu.liu@intel.com>,
	"Chittim, Madhu" <madhu.chittim@intel.com>,
	"Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"yishaih@nvidia.com" <yishaih@nvidia.com>,
	"shameerali.kolothum.thodi@huawei.com" <shameerali.kolothum.thodi@huawei.com>,
	"brett.creeley@amd.com" <brett.creeley@amd.com>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"edumazet@google.com" <edumazet@google.com>,
	"kuba@kernel.org" <kuba@kernel.org>,
	"pabeni@redhat.com" <pabeni@redhat.com>
Subject: Re: [PATCH iwl-next v4 08/12] ice: Save and load RX Queue head
Message-ID: <20231207144615.GK2692119@nvidia.com>
References: <20231121025111.257597-1-yahui.cao@intel.com>
 <20231121025111.257597-9-yahui.cao@intel.com>
 <BN9PR11MB5276DFED75FE8F9372B7A3CE8C8BA@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276DFED75FE8F9372B7A3CE8C8BA@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BLAPR03CA0031.namprd03.prod.outlook.com
 (2603:10b6:208:32d::6) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DS7PR12MB5863:EE_
X-MS-Office365-Filtering-Correlation-Id: cc11a719-9a97-4498-d82d-08dbf73343da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	FYKQp30zWoaJ3Irh0/p6Cau+61p7Rvzi6XMAdwPTHW3PVPKb4WHsknGS1fCIbeF0wU9sLOaPPjpSicdMSnDyovnYN/MLKnTZE/+BH+/P7RNWyj7BnAbdm58PA149IXCEAfLxq7FOYkRUXRBPNM1p7apg1feHLOE9ZmzFx3809AOTrV5dA5m06+fqWMekZZF6ku0mTZVFd9siL0s32XbJ6TgzAdvuardA+HG/9DiQm6jvi4lgNJYLUWWfNzNlKJ+Gw/0otwJsTDNXmtSK6syLQ/GcNWHI9KIaWvUA1uWKHPAKC4YJEo4FNdk8vLp7MIjNa33VDRUspO22urpmaBB09HdriSFH3GwZmH2XLkHoLhv2VvK+SQ/2PuGKBwzcVcOIkEa22Z8TylpJAB23XKF7kRmh46Hf5PcV2gRzgJO9FyF8s572jVchC745mz7ARWy2pvw3onrpEmV1qJt/fE6foWuyrHLd/g+tkYEW4lumhiQ+3uE86V8fLyQscohH3ucYABFbSdMUSqekB0VStOGeMJE43M/R/F+MutgGXgxFsFGqQ5yW088HdjNaoQwathF4
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(39860400002)(346002)(396003)(366004)(376002)(230922051799003)(1800799012)(64100799003)(451199024)(186009)(7416002)(2906002)(6512007)(6486002)(478600001)(8936002)(8676002)(4326008)(86362001)(66476007)(66556008)(5660300002)(6916009)(66946007)(54906003)(26005)(33656002)(36756003)(83380400001)(41300700001)(2616005)(38100700002)(316002)(1076003)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3Lp2yo4p/JDWEzNH1UeNoCbAC6MW6LSb6RFltZr98Z3gNVZg78sDvACBw9yW?=
 =?us-ascii?Q?2GXyobPoLiK9RVVJwhm/LMfIKYqy5rVtBG5q5Q+tnO00blfdB9L3UPX5Md5N?=
 =?us-ascii?Q?EbwwNATY94RrVl6fPB2+kpmUDLzkqYHvov3L+rdR1nEbb0Aj0uOw8S8z1gZP?=
 =?us-ascii?Q?6iLg8GyDzxVYYDd3ck/d0Jjn5PQJ9cb1mF+NDS6SA1dZ/Bjo/rQGbE/v1AJa?=
 =?us-ascii?Q?0iUnH+VSKJKNEXLDFujo0sGvhe8WKicwLslVb0A68FlprMJQXculHlBZZKL8?=
 =?us-ascii?Q?Sk1kMkF/vQjIVP9gLgd1pyLRxohTSaG1e0J8PvDmSOKIE6HKkcfBa7REAYpC?=
 =?us-ascii?Q?vgmbsimNystiCd1CFUJN0rD9BFNvr0eMBymeJHAOgPCAON4y+wceHws2M9eq?=
 =?us-ascii?Q?P7pEfJtbD70E5KAkdPM1CRTqiBXcPEtzCrGWae8HDcQwG6iJeWDsbRAgBhMG?=
 =?us-ascii?Q?8DGGOs+G9wklV63hV5myVQSTAvnXPcqe9SXNDi3qnLTCuXR/M/kvFgn1XOxo?=
 =?us-ascii?Q?9pviBNx+GK9CVVedfn3HGQCDi9ikMmv2HF5vX2/+4fIlidUE7ijx/NT0iR3F?=
 =?us-ascii?Q?pDsoC87wQr11TphJZU3bjo2iUpR87yxq9r/B/o786xkDYsRpHGewdnNZdeR5?=
 =?us-ascii?Q?HuAZyJXGckFG+DATPPhhjENvh33fTiXgkZ4qCHjO/3yNkvfu0TZUFCsqClP/?=
 =?us-ascii?Q?nRRJsUmZQPWb0giik1C9howeIuaL2Oo79kMg6a7YcPJpUjWdCaIo5fxjzT4e?=
 =?us-ascii?Q?c/fVS/wsyFa2Mmn1FeAACFHAjVWhdTsg5z2wGL7o+TsOrAuJH9TMjTaWRzoT?=
 =?us-ascii?Q?DjmkcpcOW83zIIkxsIWINazC2ZDeozjRgOw41mBIjh4mbnB5TwexHYMFrQes?=
 =?us-ascii?Q?O4O4keQviZxocgSNWJey/YX2bil8hX6RbS5O/I18EzjXT6bTfZRedPQqhgzu?=
 =?us-ascii?Q?93GEKPh/FYQEVoux+6ju+cTEbgSIDMe9V7z8Kv/XErbnM+xHlkhm8hbgiY4P?=
 =?us-ascii?Q?i5VzfKLCqaOkBpcn/nOgLcpA2kDM786wPt5kfoeASf8amPSLpZjiqj0UMcvS?=
 =?us-ascii?Q?xWPyQZAj5/RyAgKO7CAa2DH4cUI9y1IqM7QmvsW4I/fiMcpARi4IjD0G1jT0?=
 =?us-ascii?Q?JqvT4fw8QtEWIMwtS1V6Gs3ur6V7SJL0cYdagVtVU1mkUhX+Cd14sTpRvXLW?=
 =?us-ascii?Q?0nV5iN54Vymvv7Xohq+2OSIyMLaNKGPr2I4/Nkx7UNEtIOFoxUAMpgGXRZpm?=
 =?us-ascii?Q?rs0HP7MWrLabYNk1eMydN/CWikGchhe9T94yLDIOKW6kH+5F6bakZRc/1sIg?=
 =?us-ascii?Q?vB62ADpEKp+ZXgs9iUGlJDM1suM537jt6rOA4gvU2w4AcEzqHEmBkjPiuvcd?=
 =?us-ascii?Q?lEhPft7vGvNewjQHAGJ3SKUlmK0ysUJYHDuWN/0AEa3z9JdbdZP2XGnfiyIT?=
 =?us-ascii?Q?9AKwLtm/HNDqH8PXHzZt4pdbMqBemWJ0FkOw5zmwFg7iFZMio/6EdcQwZsuS?=
 =?us-ascii?Q?4VGy88TizyPNpA5Aw+eteRJUm9j6n5/YFLoipgrnM4CAMlypXVWpY/HApKEA?=
 =?us-ascii?Q?DQ0qahneYvlUEbC2AUsQGlC8sN8/DIq7pxFq3drv?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc11a719-9a97-4498-d82d-08dbf73343da
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2023 14:46:15.8169
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W4H7MtpxYHUVGmJr6DyEXJvHxjdAAyivq9pIXGaTwxiTRS3jqf7prUMIK9QVU9ZL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5863

On Thu, Dec 07, 2023 at 07:55:17AM +0000, Tian, Kevin wrote:
> > From: Cao, Yahui <yahui.cao@intel.com>
> > Sent: Tuesday, November 21, 2023 10:51 AM
> >
> > +
> > +		/* Once RX Queue is enabled, network traffic may come in at
> > any
> > +		 * time. As a result, RX Queue head needs to be loaded
> > before
> > +		 * RX Queue is enabled.
> > +		 * For simplicity and integration, overwrite RX head just after
> > +		 * RX ring context is configured.
> > +		 */
> > +		if (msg_slot->opcode == VIRTCHNL_OP_CONFIG_VSI_QUEUES)
> > {
> > +			ret = ice_migration_load_rx_head(vf, devstate);
> > +			if (ret) {
> > +				dev_err(dev, "VF %d failed to load rx head\n",
> > +					vf->vf_id);
> > +				goto out_clear_replay;
> > +			}
> > +		}
> > +
> 
> Don't we have the same problem here as for TX head restore that the
> vfio migration protocol doesn't carry a way to tell whether the IOAS
> associated with the device has been restored then allowing RX DMA
> at this point might cause device error?

Does this trigger a DMA?

> @Jason, is it a common gap applying to all devices which include a
> receiving path from link? How is it handled in mlx migration
> driver? 

There should be no DMA until the device is placed in RUNNING. All
devices may instantly trigger DMA once placed in RUNNING.

The VMM must ensure the entire environment is ready to go before
putting anything in RUNNING, including having setup the IOMMU.

> I may overlook an important aspect here but if not I wonder whether
> the migration driver should keep DMA disabled (at least for RX) even
> when the device moves to RUNNING and then introduce an explicit
> enable-DMA state which VMM can request after it restores the
> relevant IOAS/HWPT...
> with the device.

Why do we need a state like this?

Jason

