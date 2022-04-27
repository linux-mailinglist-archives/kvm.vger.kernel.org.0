Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B010511F4D
	for <lists+kvm@lfdr.de>; Wed, 27 Apr 2022 20:37:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240071AbiD0Pmp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Apr 2022 11:42:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239986AbiD0Pmn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Apr 2022 11:42:43 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2061.outbound.protection.outlook.com [40.107.243.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D392B1C9;
        Wed, 27 Apr 2022 08:39:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BdgHZ0dhniQCUXSwbVngx3+x0EpE+jlGkVk252urOyh4ctS5XTUWSuKgA6QPGFkHiQUuQgfz/rcpOaMtdZJJGoIOid9jmcEDCkxXXLZReXpD0MQ9BDM8zNDb/2sf/K9GU38HA4QYeIrb3evg3/pxNpbdOl7BLFnqTs0IjNFIma2ZkDPodC7wC7iMDlFmza4lUC07C/0Qjawgzsage6FqZkK0grXHlmMtNRbS9DTb4KYHoP4A2G/r9kOoUiYe66dSq7J6VddaQJfNz22wtWUu2IHmjDH3AmO+knHO26EGbB3pbixzAZQum1VecG9dsi2AkCYylFMwq+uqj2NtS4LHLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3w3uGNnNj9C5O/XU7QTuwQ1oyNC9/cdH4Nh0g3yhvVE=;
 b=HtfxErF6+FW6d4dz+hp8JRO5jaVcuYimgAaKNxGyL2dgVo2if150DfYQ91tjX9YECSpvo7KE+qLyfZZ2pUKR8UKyfr9jQXvyNVwq0XqN6odx/soWCYz/43mBRzNwesOaSIrk4P8TsqDr6pyzEfo3GBcALLmXpER9pnFw4mcp8J9iTIypl251fOEvN6E0p8JpIr2h8HEIOCL/u53QSaxA1bt6uIDB3hbly2JfWLR1vp7dY+ZPaWd8n8XkWybs6ie2LTRPredvUeZ8IgnPaXqSR/XdFMOspmzGQgaFz3WnGnPr+0dGqy1MpyI9hdOj6Zsf2hHP0lCoywbZXufyqBgxGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3w3uGNnNj9C5O/XU7QTuwQ1oyNC9/cdH4Nh0g3yhvVE=;
 b=eCuEgNPz3pEVABcA+ndOvOZWe7U1D+2t/Cke8J4CoJp4EOUmTpQ3MrbqT/+5I+2Wz9SthAB9iejfDsgyJoJPxvBTNXNKcGlxqlBZgqCAxSCZKpxXevGm7Zo2wmgqMwkv4Ei4eU1C0q1YTrcxzBi0eUXf1QydY6lQmLDg6ud7VSP+gUdAWqbIRZoRRgFcmVz2EojRZThqibj8cRy1tKl+syIn1gsLG9yHJJ+bHOkhnHzFCjaRCax8TUc7mpDRwcJz3wP7E6iNoANUt7QKyvBZTzE5oSQCMAly20WCrj5MeL3ghC7TsRC4cBlEP3yG4cvo0OvsJcjXTkaWHSLtkvVFBw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BN9PR12MB5083.namprd12.prod.outlook.com (2603:10b6:408:134::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Wed, 27 Apr
 2022 15:39:26 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5186.021; Wed, 27 Apr 2022
 15:39:26 +0000
Date:   Wed, 27 Apr 2022 12:39:24 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, alex.williamson@redhat.com,
        cohuck@redhat.com, schnelle@linux.ibm.com, farman@linux.ibm.com,
        pmorel@linux.ibm.com, borntraeger@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        agordeev@linux.ibm.com, svens@linux.ibm.com, frankja@linux.ibm.com,
        david@redhat.com, imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, pbonzini@redhat.com, corbet@lwn.net,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v6 16/21] vfio-pci/zdev: add open/close device hooks
Message-ID: <20220427153924.GZ2125828@nvidia.com>
References: <20220426200842.98655-1-mjrosato@linux.ibm.com>
 <20220426200842.98655-17-mjrosato@linux.ibm.com>
 <20220427140410.GX2125828@nvidia.com>
 <f6c78792-9cf7-0cde-f760-76166f9b7eb7@linux.ibm.com>
 <20220427150138.GA2512703@nvidia.com>
 <1bca5de9-88aa-6abc-88b7-cbd2a11e5c85@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1bca5de9-88aa-6abc-88b7-cbd2a11e5c85@linux.ibm.com>
X-ClientProxiedBy: BL1PR13CA0268.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::33) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2a081e1b-a000-48da-5c3d-08da28641c24
X-MS-TrafficTypeDiagnostic: BN9PR12MB5083:EE_
X-Microsoft-Antispam-PRVS: <BN9PR12MB5083F0E6FE5335FC715D44FAC2FA9@BN9PR12MB5083.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KZkv9cHbBu+Z4cbNVTukQkpff+gLxyPAcn+sahn/GX4SWTrOZ+rByCI+Wo2TQ//st+oBl+0rIlTVkLcFhImOhPbFSf5GWczngcHW35S0uuX8N40HBTIdPih4rSV7mDaHPFIkHV4PPBJ9/NKO9WT86EWuCbSP3DygJk9uV12fB/QX86heZULjxhO9v4hcBHewQdZwX/HTTgP2cQBwbPDLwKeSjAqBXzhwLs6cQNO2XjN75IPjcfVnti3VPzdli3V+t0kvFqfVVgh/EH2qfj5VadlzngI/vdWewydFOk3uCB7HHaElEY9duVh3bMPLYcbQitNaQM4ITwNjWOPdyJMGa3dEh4Q9x35MrtgXs/d3UG+R299Tea5lm5yip5qUGLPbcW8hprklZ8RezS0GJ23dPkh7RKQ5y8YV1FSCZJCu2ZPMEA/gHegxvTwtjvlcXU775dAWCS2SlWBuvbEIQpQ7GBbnJfgkxZXUgH7y8oImxHKBnjU+M1w9MPN0oavRvv6nUnIkOMzpG6CIaIzv4KA6DHFHZQyoUkb7vreRKgczIVxVokoSuzkTOOCRctHglRuI3XxSiNlhNKk7TJOacW1BMCbKOPzvevJulDIHOUnwm7GhShsH0ofK/4/fWBx67JbNdO7vAqI1fPo2irkXNlYImjEs0qSZLhC0pLyICdxjT9lI1IdnUcIZAfGgRl9ZWF80+KJj9rAAmDosFeMgXvTR/VO4PbFUx0MwsLTHukR0U2c=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8936002)(1076003)(8676002)(4326008)(33656002)(6916009)(186003)(316002)(86362001)(6486002)(7416002)(966005)(2906002)(508600001)(38100700002)(5660300002)(2616005)(66946007)(66556008)(66476007)(6512007)(6506007)(26005)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kfAe63i7Pma9S0lNS75G4jKHZ1z0mRAqimj5vR1KsrS4cu7zCktC6cOPcQIv?=
 =?us-ascii?Q?SjI3YPsU8qu+sq18C3tTQV+JZIMX/Nw5FPg3J403bVlahOEDrOqOzSpQKg69?=
 =?us-ascii?Q?3PN0uA/Hl8QaTLUIvpl65/uTfcD8nb5Ij1e9ThfrL8aBFIVLOJfLJNdI36Om?=
 =?us-ascii?Q?eFv8pPOZi+gi4XuwcrYynJWNeoXevwiThmD4EHCN4CKvqJB0Eki+0oaRWWgf?=
 =?us-ascii?Q?cAQtSAqU9K4BabT0FXPeTEhq9wAhfIqn3Cft8b/QzXIKuPWf4gI1Um7lRxmd?=
 =?us-ascii?Q?bBQWuoHF2xzWrHY8pF05Zed/YvldGybFqI3/ktnTHGOP0I5FeZaqrzMlfVUv?=
 =?us-ascii?Q?n5plL8kfm566rh6j1eUrBvkPf9K/vl8gbeg2WISEZi4h/m6RrRXvRFZspWg1?=
 =?us-ascii?Q?mjTxs0Xx1pEu9nvqPcuR+BdNrkz6nblmSpjZpAcnjKRv98gpgLNc/R2uWBG3?=
 =?us-ascii?Q?eViRRM79WTioEoznQ0jETSB5Il1jstFabY0YQZPdu5DK9ptFiPL0efCQrspb?=
 =?us-ascii?Q?o2orpBikJXEGut4rLUbmq/V2MeWDP5ATuXhXeYFw3x5b6pVVRozqMMpJVO3L?=
 =?us-ascii?Q?+OLRtusZvwYNM7maublhaAqBycIzJWbTTAO8Jii6u/k37WKMe6qxkiHe4a5I?=
 =?us-ascii?Q?WL3PUuf48CJSv81ZSW7iGZIIgPYywC6sXkBk0Vp1aAEtvdoCPVovoDVasN+2?=
 =?us-ascii?Q?ZSvbC5kK3A7NVSdu6c+0FFicwxi5mluntIm23SbRuQcY0axSAn8cjXqwtlei?=
 =?us-ascii?Q?F50RYqtWlSKoETe5s28RLwP/qeDZgm2LFoynXGXrC45m+wukFBoQKJ5qgYjM?=
 =?us-ascii?Q?gifcwJR2viGBcfK+5u7rQif7hgsEBZ0pxDjIEUpsQijUI7Y2pnXko394Ndiz?=
 =?us-ascii?Q?Ud4oU3mgcGlMJIa1GdY9E2pGOQDmustvMXOcMj5iSZacEixI8bzgFYgwx7lg?=
 =?us-ascii?Q?0IhTDb0m51VFtYoi+KV7zRoWCmJxZjwBv63Eu/doQZCOnbnNtSOzeI+oAawI?=
 =?us-ascii?Q?eNOTEEfRhPpS0w1ua6qIGIhvmqb2NdlMEgekaVmjKbIEaDvsq8TkqDkn1B3V?=
 =?us-ascii?Q?rDeez9SA8NmRtDgg98avXOtG4sAfnSWFP+hMKUUhwjDvjVtMb2cf6z7ME6S1?=
 =?us-ascii?Q?DlUextKUluGRCrvQRAoi9jxZcZQyPB+UOt4sa16JI1LwdfevGiBGY/kFGlif?=
 =?us-ascii?Q?CcKNH5VsNK2aLPKUUn2HcfD/elU+L2gcyTvy4f90NCR29pJvUE7DQkuAn024?=
 =?us-ascii?Q?iBbPPfRKZfTQVofhu+7ndtkKcTkSTzHr9l4DNiFEBglsqLJqwY74H2yHBR3K?=
 =?us-ascii?Q?43rnF9fZliALOnXgpr1aQzIbllU426TJu+RAqhq1+PjfrWTfZ0sHCDUgKCBC?=
 =?us-ascii?Q?KNJE5RQ2Wos5gsi37FLvoTu28UDwT7n7H7Zk7NYxY7a5G3+VvGHBTmo4cGFI?=
 =?us-ascii?Q?EiZifo2NM26cqlHBlpYFv/yXhSxkaEa5IKfRBZhDtbS/I1qotuBF9xFMHHiM?=
 =?us-ascii?Q?hIjdb721ormzAKV75boN/lplkYVVOsJu/qSpsWhBcF8Hx/mN7y6+fMgRxwZ5?=
 =?us-ascii?Q?lFb6mTprk0t9J6GUbx/GxDZv+Nrcr7dmS2n4sa4z6QeEg8baQFWyXRzfw17I?=
 =?us-ascii?Q?SURQg34jzyUk2qbkw7Nyacocpk7nO7Doq999DCZMoZACfbPImpJ3Uwxbi0xf?=
 =?us-ascii?Q?xz+MQJVVUEWR+wr3Im2bXDTMRkYbAhMPOS9wjwCweOXbkdhGsASsT+ZZt4Nl?=
 =?us-ascii?Q?rQ0/1mp0Xg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a081e1b-a000-48da-5c3d-08da28641c24
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2022 15:39:26.2675
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fccPEF2UuJ35KnZnMBJwb3Npg7/PQ+WsZs7pMbTFXpj2zCtECzvWTZP7wRbOxEhK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5083
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 27, 2022 at 11:26:40AM -0400, Matthew Rosato wrote:
> > > zPCI devices (zpci_dev) exist regardless of whether kvm is configured or
> > > not, and you can e.g. bind the associated PCI device to vfio-pci when KVM is
> > > not configured (or module not loaded) and get the existing vfio-pci-zdev
> > > extensions for that device (extra VFIO_DEVICE_INFO response data).  Making a
> > > direct dependency on KVM would remove that; this was discussed in a prior
> > > version because this extra info is not used today outside of a KVM usecase
> > > are not specific to kvm that need vfio-pci-zdev).
> > 
> > I'm a bit confused, what is the drawback of just having a direct
> > symbol dependency here? It means vfio loads a little extra kernel
> > module code, but is that really a big worry given almost all vfio
> > users on s390 will be using it with kvm?
> 
> It's about trying to avoid loading unnecessary code (or at least giving a
> way to turn it off).
> 
> Previously I did something like....
> 
> https://lore.kernel.org/kvm/20220204211536.321475-15-mjrosato@linux.ibm.com/
> 
> And could do so again; as discussed in the thread there, I can use e.g.
> CONFIG_VFIO_PCI_ZDEV_KVM and make vfio-pci-zdev depend on KVM in this
> series.  You only get the vfio-pci-zdev extensions when you configure KVM.

That make sense to me, I'd rather see that then the symbol_get/put here

Thanks,
Jason
