Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A87B6770C15
	for <lists+kvm@lfdr.de>; Sat,  5 Aug 2023 00:43:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbjHDWnx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Aug 2023 18:43:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjHDWnw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Aug 2023 18:43:52 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2085.outbound.protection.outlook.com [40.107.94.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9236558F;
        Fri,  4 Aug 2023 15:43:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E4daR66F0klWPN1ndFS+3HzjXnZQlyFgIwRc9UDz/9P4cl4S7B0lRBKIa3bbL1523YUQuFfghmbKD4w4urrN8rDZbj83Xv8krRrTV0T7YyPbqNvBaV/2A5A719qw6qnAPlT1s5Pj1ZOd4Di5awCNvlHZjItN8HmVp3LX4h4x5it3zI9pPg93MaR+4DTGVRUDJ2rVkdxImPDj/XxmmGERiUMdsriNX3afFOvFSzg3ATJAHNanKewrOizX6imS4DSzO8ZJ6tvld65a0UIuy7qzUxiGiZOv0QxgAlLWxB9DoMf2EckiidikVmv6RTv56e3hBFKQrzhD+bLSa5Eh++frew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3tfX43VGu9CvrRnZf9RPfMgucrghFJdB3kQBQGeIzIE=;
 b=DNrj8iJrY37e3vzi0kfi6DpCzIDBJ+2d012iVhbu6t0xTY35bMuRyG8oCUdkzYWIzzOdZO6B6nDuJYi8RNDTsKH+wuWb6qnjENozb7vNO0CF8eXe2FUFA963Ok9OT83c8C64xqFYzpL1mdpEaj+gxKQStcasrc9O87JqW6NE9hKup7PVje26PA5Do70sdpxKuUlv85ocJgDMb3QeZJ4yyhW4NdUbwXH1/t5vehunGp5/z/Y5X2OOOmbNIgO159XHz/HfcDIKG17dSXDwsMChXqviukZ8ANfc5JrbkZsswkgw2/mCI2KWOduHJbSivUwqKeLm47UKsuVV9kVQ0zmQBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3tfX43VGu9CvrRnZf9RPfMgucrghFJdB3kQBQGeIzIE=;
 b=Gs1WG8dMwbVY77EBnozULlewe5zlmlFcCZbmYPLBI5nQCgOjMb6A/8dznlmdzNSk6zygDxyszZXldYu7QFCTwlf9+YurVeMu5oB7VTnjNzcSOX1Dpuo2L21Db18y+DsRiOi3OKbxX1c0zeb5yEUsaRGB0R7Yo9KV1dAmOWxKgUadUIP17RmQVTLFR6TjBGdZlMjyKfvsniS1MyyJneg2hvLyygCG/7MEZEkoISFOWZPQtcO6Nr+6ck5KOCferaIIpJgqWnQQlBINcxnWhg1z5nG5ptc3lutaew19xhblBX+38A2J/j2Zl13a9xt4ENd27Uy2/vNPPyQO91QU01G7cw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BY5PR12MB4129.namprd12.prod.outlook.com (2603:10b6:a03:213::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.21; Fri, 4 Aug
 2023 22:42:44 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::5111:16e8:5afe:1da1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::5111:16e8:5afe:1da1%6]) with mapi id 15.20.6631.046; Fri, 4 Aug 2023
 22:42:44 +0000
Date:   Fri, 4 Aug 2023 19:42:43 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Brett Creeley <bcreeley@amd.com>
Cc:     Brett Creeley <brett.creeley@amd.com>, kvm@vger.kernel.org,
        netdev@vger.kernel.org, alex.williamson@redhat.com,
        yishaih@nvidia.com, shameerali.kolothum.thodi@huawei.com,
        kevin.tian@intel.com, simon.horman@corigine.com,
        shannon.nelson@amd.com
Subject: Re: [PATCH v13 vfio 3/7] vfio/pds: register with the pds_core PF
Message-ID: <ZM1+48h9EcqqXrZI@nvidia.com>
References: <20230725214025.9288-1-brett.creeley@amd.com>
 <20230725214025.9288-4-brett.creeley@amd.com>
 <ZM0vTlNQnglE7Pjy@nvidia.com>
 <44535ea4-9886-a33a-7ee2-99514f04b53c@amd.com>
 <afdd5231-cd7b-c940-7c51-c522b4cb5b90@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <afdd5231-cd7b-c940-7c51-c522b4cb5b90@amd.com>
X-ClientProxiedBy: MN2PR18CA0016.namprd18.prod.outlook.com
 (2603:10b6:208:23c::21) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BY5PR12MB4129:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c87b936-8794-4d65-70ef-08db953c1e35
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aE1VLK8rG/wTBN6Qx6bYdBGHCosw/nmCo5VT9B9DeBVzTFS4my//hslAcnU2HQHuaZzbFcYRpOsooYtPK+tFawdw2WtvdaGOJjaTYaSBgaEslKs5THpZw7C0nu+YCAwKkFHYDZ/pMgQwOhUlunsySwLeg+mc1QFmu7FouRdwgYc1vAS2pDPT7om93vfbpERD1BVoaZKXauHtbO5S9yGc4EKjgVZShJO4I43U1+oBeBc8n8rNtFKokL7M3/5ripnOHX45NLsoKLJ6x5kawKkl2NT8ummGbofOLGBUH3FPt1rVKchosuzFaiygnrjzrQRuduMb70wRMkqs+EOBPn8ab6tSE6qh9xSPH+wpid3/FwfAVvbSS1nEWqRHQgvRxcSLiF3BaFUEn56+hGru1YqTkFMBGjxds4JhGka3xoV42EZUJsZnikTr3g2r8187xzDDH7mvnadX1oQG5SONvOPS9feOFWDuNDPGsZV/I5nLL07+ECQDeeaqtk2Y7pV7QBJ8zAj87kqkaMs98nM03ULmvbd6k0TWmoBGmu/YBbRiZ04acH2HFMfBO83w3BqpUMBkn3067k8H0td1EjcnWv/xjdyk8NTE4NUkZ9SNAcCt9Hc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(136003)(39860400002)(376002)(346002)(1800799003)(186006)(451199021)(8676002)(8936002)(478600001)(36756003)(26005)(86362001)(6512007)(6486002)(316002)(41300700001)(5660300002)(4326008)(66476007)(66556008)(66946007)(6916009)(83380400001)(2906002)(2616005)(38100700002)(6506007)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eS9mYUJZS1FPZDVjSU01cE5mazU1WVNSeHRHUlk5dlhlRXJTNVRwRFpwa0Zw?=
 =?utf-8?B?aHd3UmZEWGRaa0pRblhuVkFxUTZad3UwMHRpb0NPTWdXQTNjaThOcFRlTzZJ?=
 =?utf-8?B?L3REYlBBV0ZXb2owZ0lqV1lqbmlnOXVSb3NwZXEvWjlUZ2JldlM3Rm5GUjhR?=
 =?utf-8?B?VGRSemtjbFhWRzlwK3A3KzAyakZOS1diazQrOWhrQ3A4ZU5MSnRudkh2UFRC?=
 =?utf-8?B?MDEvZysyRjQ4OUV2UDlCRGJrUldIaG8xc01DcmRBTGdpSy9vdC9VaTdGKytE?=
 =?utf-8?B?akxydFN1eHVueExFVkJuQVZHY1dXbWUzb1RkYTdDRVhnYmJ5V0h3ZEorYXdU?=
 =?utf-8?B?ZXcyTnhweCtFV3h1YXNVU2xnNG9DUXhBeHF2eGRlWEdpTnc3VzVvanVpRkxO?=
 =?utf-8?B?bmpockpoMlJiRzRoU3VyUHZVMU9aRWZKa3RoWkVlajFXd2VJVUFWT3YvUFVO?=
 =?utf-8?B?bitQRUl2VG5MUmJMVHBOV2FTd2xPNVFCell3RktBNUQ5VjFoRGVZaGlzTmcy?=
 =?utf-8?B?RmFCN3k4TG9NSzkzbDI4UExLWUptRkdrUE93S3ViaDhBclpWdjhZMXQrOGxY?=
 =?utf-8?B?cVRiVlhoWHIzNEFsNWhHVjJRU20xTGUzVGplZzk4S3RWL3dhUDh4dlpKY1dP?=
 =?utf-8?B?ZUVkblIwUlBNc0RIVXZWZmF1cElSMEJ6Q2RFT1pQMDR4a0ZORmNRYU5rZ3Ir?=
 =?utf-8?B?WDVDcXVEZ1NoQU16RW85YnV0aXRjaWl3NWw4ZUwyMjQxQXN5WStEblg3VmE1?=
 =?utf-8?B?RmRlY25SRTJraURuTFVCU25vdC9ObkNBV1NyVjVwVGVxeGhSZnZoV3Jzd280?=
 =?utf-8?B?ZFd1Q2lVc0pwUmZnYjhMSEhSSVI3SVliV3c0Q3NYZlprRjhzeDhYdDFrSDM1?=
 =?utf-8?B?bnFDK2RvNVI3Umx2TFlVd0dFL2VlejZCQnNqRGN4SEJKelNsWDFSd211VjJ2?=
 =?utf-8?B?M0gxTTBrY0dIbkhQRDdpRDIxMTYwbExkV0RyMDRwNVlpK0VlMnhxTVN0SGhQ?=
 =?utf-8?B?bHU0Q1ZSZFgwUHkvaFc0alJkUC81VERiOTFIa1BLeEIvcE9xT1F6NTBzVG5Z?=
 =?utf-8?B?NUxpTVFicE1scUhQUStxQ2VsQTcvNnRaeFNPR3NUR3ZrY1N4OTlKVVQ5d1RU?=
 =?utf-8?B?TG5FNS9zU0VUUFZTK0E0ejdBQ1VMZ1dnZXFsWjZOR3kvbzlsUFA4cGpiUCt4?=
 =?utf-8?B?MlRxNitUY0tqZjExVVNUZ2RqTWNRdDZOcjkxc2dKS1R3eW5FOE10ZUdGa2hU?=
 =?utf-8?B?OXhWdi8vcFRXb1JFa3dhYkQxb2VWbHNudndXalg2UFVCNlEwNEdtaHBBN0tk?=
 =?utf-8?B?UUlncjJiWGUrUWNHcFI4T1MwdW9uU1IyY2NMT3ZlVEZpbDd5R0l2cGtiNGd4?=
 =?utf-8?B?WjJzN01nYmlDQnF1MjI1ME10d0R2dG10ODVlMi9wZTN1dWVxb2MweFpHTS85?=
 =?utf-8?B?aEJGZFQ1ditTUTBTZEZPOG1lMS9jbjVhUGV2b3ZOZVhLeTBwRkMwZ0lka2Fw?=
 =?utf-8?B?Mk91SWxad0x2bE5jUnlNTjZWZTBjUVJFNE92bnNmZCtQUG9nZ1U0Z2xQQ0g5?=
 =?utf-8?B?enF0VllrcGpFTUF1NElHZ3J5UTl4V0xubERXd21CZ1VzZ1c0RmlUUzBhQUhp?=
 =?utf-8?B?RFBwc1RsYjhsOFpVVGhLUjVPN21DYkFQV2dCZDdGaWFqaTVsUU0zcWUzK1JX?=
 =?utf-8?B?QmVlZDlRdmNMOTJsUUVXZFhQb1VnNjBQbDdIMW0xazY0VlAvMFdUdGFxaEwv?=
 =?utf-8?B?c24rTEQ5anZaOVhRaE8rNGRUYTBtL2g5TlV2RHplZ210RFAxL0hpTXh6eHpr?=
 =?utf-8?B?T0k0K2F3OE5XMVl0YXVOdWFBZERxRVJQaytDN2puNDZvdlE2b0dVbFg5RTNx?=
 =?utf-8?B?ME03THRYVmRBcWU3WElVL3RUbE5ZMjlaNFR6eXR3QnloOGNLZmVMNW0xSFdM?=
 =?utf-8?B?WlRsRGx2MUQ0QXJYQmZuYUZmSThVRko0cFloUkd2R2R3UHBlZDkzTDFIZXN1?=
 =?utf-8?B?cElUWExkeTVEN2lZV3hoMGV0Qk8zNFhMeWw3U1ZPQnlvZE9nbjFUaVBvZGU0?=
 =?utf-8?B?T3pqbzgwWjVYTWhoVDZQRnQ0VEZ1eEJvWnc1Wnk1TmF0MWp3U2gwbjVHV21a?=
 =?utf-8?Q?EqHOEsur1K1TVwjBG2Kz2WdIw?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c87b936-8794-4d65-70ef-08db953c1e35
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2023 22:42:44.2355
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dFwTlpEvTkGl8D5WPHgTf6xlxIKSy50+Q3lL350S3weXaAzH448R0ftf4g2e5+FX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4129
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 04, 2023 at 12:21:21PM -0700, Brett Creeley wrote:
> > > > +int pds_vfio_register_client_cmd(struct pds_vfio_pci_device *pds_vfio)
> > > > +{
> > > > +     struct pci_dev *pdev = pds_vfio_to_pci_dev(pds_vfio);
> > > > +     char devname[PDS_DEVNAME_LEN];
> > > > +     int ci;
> > > > +
> > > > +     snprintf(devname, sizeof(devname), "%s.%d-%u",
> > > > PDS_VFIO_LM_DEV_NAME,
> > > > +              pci_domain_nr(pdev->bus),
> > > > +              PCI_DEVID(pdev->bus->number, pdev->devfn));
> > > > +
> > > > +     ci = pds_client_register(pci_physfn(pdev), devname);
> > > > +     if (ci < 0)
> > > > +             return ci;
> > > 
> > > This is not the right way to get the drvdata of a PCI PF from a VF,
> > > you must call pci_iov_get_pf_drvdata().
> > > 
> > > Jason
> > 
> > Okay, I will look at this and fix it up on the next version.
> 
> After taking another look this was intentional. I'm getting the PF pci_dev,
> not the PF's drvdata.

pds_client_register() gets the drvdata from the passed PCI function,
you have to use pci_iov_get_pf_drvdata() to do this. You can't
shortcut it like this.

This is all nonsensical, the existing callers start with aa pdsc:

int pdsc_auxbus_dev_add(struct pdsc *cf, struct pdsc *pf)

Then they call

	client_id = pds_client_register(pf->pdev, devname);

Which then does

	struct pdsc *pf;
	pf = pci_get_drvdata(pf_pdev);

Just pass in the pdsc you already had

Add another wrapper to get the pdsc from a VF using
pci_iov_get_pf_drvdata() like you are supposed to.

Jason
