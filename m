Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46BBB706DB5
	for <lists+kvm@lfdr.de>; Wed, 17 May 2023 18:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbjEQQMH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 May 2023 12:12:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbjEQQMG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 May 2023 12:12:06 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2058.outbound.protection.outlook.com [40.107.96.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 848B540CC
        for <kvm@vger.kernel.org>; Wed, 17 May 2023 09:12:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FKOJtB0RRkPYTey6/wKeh2S/Kzp+Tvh1D2DrrGx8iDZQ7TdZ3PiCdRXtKoQvBjzL1NHNhAKdWD/nBcD+YiHvpbcAnjIg5VxJIUarR3KG1wWLbNjEH6+WPjYgRCjm6aU8IZP7udxDqH6hjEoERhy6uJ1cZEKW+5A7v/8VT4OtTqMlkrJEgfXPd1QaKuMu0sbzBTPeLwV2o161CsKQgIXZSSFoVPKXGXN3DLey7xn1+ClDva6INFBA3XrYC3lIPEKgzHztRyh2f4OWuwS3fXWKQW7wYAAOTC4jA2Mrq8DbkOgLJI7LTjxvpUqTi0sg09OpdHg5kj94Dp9+5CGa3h3nug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UkZjhBobqQ7lN4Ml91TCO5rQ3Q4qFSKyz8sNpOHTZdk=;
 b=cA3GFEL86k5cuE6Cyhu42vxK27MNaIrpowv9Dlg5p8GlGwFliKEahziVF/7yfn4HTDduJEFVZkt4RIXuo/vFyBOT9SF5os+VdBINDcPw0+J8MVNA7XnfDqmYxnsLRyQFEKQnTrkj6CtatdvvMwNpNwk29tAXoAuPq3wXhwM1RVwY8ma6KyHuWDKP3iHU+2OKJW8Whp2HKzn684gnnWKFcpBd6m9V9kgF8qSzDqNUke5bdF/sdU5UrmWS+3CAXsf3YF9Q99QFhgTe1hrLCcGpGSDapcBz/EqrhFsyb2hcAc36jBZ/uvjk6lgVX+H18js5yR4El44vXDc/rDITEvLxbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UkZjhBobqQ7lN4Ml91TCO5rQ3Q4qFSKyz8sNpOHTZdk=;
 b=H1GqbuZZlqC/FOo+knDpTTrVfIGoXheK7dXcfL1ko4lhRGLMa+nrkS3GCKY1bIju0GTYrbpco0lF6jpuXRkc9mGwSyiTspeSFfcPrKBRQqpnkEAm2Sf7zLzxaXnnkj6ksg0Ky9m9vE8tHC5u/vvgxyNxPzDHVNnwntKnOgd6UVzGUsMxC/xki8xv6hpbza/vuC5g6zYAuUpAzidIIjgBHH9fF1HuSWao/FhMT+Hh+TPBDzKQY/EAoOgnMwW+UZqXdTn9wQf8VqCVili0k9LV+H6Vwnyhf3dxuNAPn0vSpkP0wVws98JShx1gw+qs3MsScxXuvwkPINpv0rOku4Tt5g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DS0PR12MB7803.namprd12.prod.outlook.com (2603:10b6:8:144::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Wed, 17 May
 2023 16:12:02 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6411.017; Wed, 17 May 2023
 16:12:02 +0000
Date:   Wed, 17 May 2023 13:12:01 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Steven Sistare <steven.sistare@oracle.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>
Subject: Re: [PATCH V1 1/8] vfio: delete interfaces to update vaddr
Message-ID: <ZGT80dRx6D8e4IlW@nvidia.com>
References: <1670363753-249738-1-git-send-email-steven.sistare@oracle.com>
 <1670363753-249738-2-git-send-email-steven.sistare@oracle.com>
 <20221206165232.2a822e52.alex.williamson@redhat.com>
 <7614cc78-610a-f661-f564-b5cd6c624f42@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7614cc78-610a-f661-f564-b5cd6c624f42@oracle.com>
X-ClientProxiedBy: MN2PR17CA0031.namprd17.prod.outlook.com
 (2603:10b6:208:15e::44) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DS0PR12MB7803:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c1058eb-eaff-49a5-8cc1-08db56f1731a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K20y0bOkGzcU2AN2moDdruE8pnDx4HGbFbUIg8nb0jwG5q61u5+Swk9FefoSM9fssnUORkzSmxUf50MQYJD3g4YyQ07DF/u2R1BnEIu6n0M4WqWVVzc0g2KF8g+UDEU82jK7Wbt3VmXL3DHw/yoobNGl5TPmWJs1GK3/bHOcZCvVmpGD7cHNNh89icY4Hh52Y1FU8dDu+eOHfJByWbu1pQN/ekgia/sm4UjsRZIHQjDfDA/Cq7fVXvWjyX5wNz5ZnZiiG5SOJVA3BzQelhPu0BaMikAf2tnOnPihjiVkAmLVSOgw5T/tce5uT5SxQEE/LgYuvCX2zgG4gBKMR5pbwZSuDpcFeeqjnq+KrHMzm4oRuZrMiTdq6saVAcVZ+AaXJ8EZkVze+/s/lT1fJsHwp2h5l/vRaRdF0HHe0IC+zNTxIvor4CqmUHuh9caPPZVOOF0D9IdTNEtY90ah/0jHB8bvqOataVINae6esuuooZ39+Dnf0qM2M5V/AyMNgIagLheRn7fkRqCR/QCm79qz1linjf/ShvuEUGphLO/BfEFFnkYiyvD6pUdRbHbG9UPJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(39860400002)(396003)(376002)(366004)(451199021)(36756003)(4744005)(54906003)(316002)(66476007)(478600001)(86362001)(66946007)(4326008)(66556008)(6486002)(2616005)(8676002)(2906002)(8936002)(41300700001)(38100700002)(5660300002)(6512007)(26005)(186003)(6506007)(6916009)(83380400001)(66899021);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?a1aREwsGqYo+PVKIUp4zIuWdkIMQiV6Yg18+ZWi2cLU8y1OfL4bmgOpUUwBr?=
 =?us-ascii?Q?I28Pyk43JmmTAMqqWdwpNCc7H37tj0hGVj58LZNAPFGG+yxBMgZCPtY3W6NR?=
 =?us-ascii?Q?jmdz3dBxKaQNBLZjgZB2zXkFZAonY+MBaYLfinmIjYAteDPLD8QIidm3g4ey?=
 =?us-ascii?Q?nIt9Mtw75EZU+hI0M5SkeEy4pGoU1h+W/hQoZcIoWrxEsqgai5cdaLEFpXSt?=
 =?us-ascii?Q?FDZj1znBwY3NhWrMVJKuGFlXYPQEjcZcTFfcPwwUamtEarfao3ccmC8RVoNS?=
 =?us-ascii?Q?wOkapqD3f2zRB0ZVXSzozzgnauspvw4c3ChryHjl3fOW6kuBF/R6VsF4uP1l?=
 =?us-ascii?Q?cTo7GV1ggru2zEbcTgB2OnRKLNCWhJ59mo3f8x1DXB1SQu8lZN9yMxyzV1KS?=
 =?us-ascii?Q?sLQnssMCu36+J3KRlF3mfIra2BcNKioSuYp/R2YczlN7MBeZiYwFXWYmCSlT?=
 =?us-ascii?Q?G2HM3oKqkZcVLcLS24Bl44OEYBzG92yEPVDcHA4ygeaB3bWfxjK12bU4/Miz?=
 =?us-ascii?Q?wTirJTB8HpFmnmKLknnqvHhRfEMAhXFiE1Ez2FShVgleqDJ2U5nUOz3YmECz?=
 =?us-ascii?Q?FRzOEPfUTVDttnjGOF9JaQxq1os6Y3aj5cVW8m1mQ29xKN2SSVJzn6a9aLfQ?=
 =?us-ascii?Q?AKWnRFgxGw3BHEbi6p43/c5HkGvaHASZMHYDuu289DQxZ/d+wzOk5KTJDO4c?=
 =?us-ascii?Q?9F1/qPy0sAqDLzHKW85Z18/B2KrQoI7KbCpZVqe5XQxIAzH9TdAc8+FLZyYH?=
 =?us-ascii?Q?Jsz0RnrxFw+QlD+WdCvsCEXmyAEPq85bKZBLJg6Yn9dKkHTQKjVyhUem3nLF?=
 =?us-ascii?Q?gE9YNDN7p/WekTn3gaHmb0Qe+Eth2cQK4ZJmBP5qmVPmH3Fh+dfXmjHkw6u0?=
 =?us-ascii?Q?bvC8euoFtuEOcyeUq1KAhAwFMVfCHIN4lJ+ICYsgKI1WTpMpc2VLIpKEhNu0?=
 =?us-ascii?Q?UjM7obUEnzf7uVs5E5YlavCGr+sJyuQ2IJx1/ybrwRFCD7QdFF+JsRKN46gk?=
 =?us-ascii?Q?EkGUCprHhF0lrbWWKg+i1U/fFfTDNyVlchiflXKMZYUE5fM5JR2wsicUYDnr?=
 =?us-ascii?Q?YPnP0/t7zCAdi34wQGwJmgLMmTSai8sJdu49M8gvSDPgyRcsp1QkWMy8P9pE?=
 =?us-ascii?Q?vpk7o9ISLzb9b5Gu2eD/ADGDCT3hU87WtJpIfKUxS91hZvg8osOsftva9WSa?=
 =?us-ascii?Q?I1xcyaq45uSdp1NW5zSIUghhmF3ky4SiPNB+0e6tk95jTCO9mczsodUHl45+?=
 =?us-ascii?Q?4iJglbIHp31K4tTupuBdaEI8wELpT9SXSxxLcX/bTO2fCgklyS/La7DNH7CG?=
 =?us-ascii?Q?6Z6ajtYjcvR5YSQJLm1mIFUFpK+u2kmafUbopSfo3JmyppTShU2G4gpI/W8K?=
 =?us-ascii?Q?i/w4I1pFBNIipQl8LZAHUYmMxv0DDX+2u7dr7i/uG8pvhjyQwGZRBEWnV/wd?=
 =?us-ascii?Q?hoSnvF+0fLO7KrOwhg5G8LeD7biA6Vk2JDtbuTvJMn54gA4QpTiudfmdjwil?=
 =?us-ascii?Q?oXSbKw6bgueN6IGrpG4c2xQXGIwxIMRME6M9beVM4nHIH3Oh102JR2fhOzpv?=
 =?us-ascii?Q?P6ZiwJNJELqzf0pXeIJbITj3R0JhLBHJEi7MPqpd?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c1058eb-eaff-49a5-8cc1-08db56f1731a
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2023 16:12:02.3961
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aGbdzhk7Owb5EXELfr4IQf1zagHYc4sDFwHxBsPO2QU9qWZhLGUKs1jLxEUXmEEb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7803
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 07, 2022 at 09:26:33AM -0500, Steven Sistare wrote:
> > This flag should probably be marked reserved.
> > 
> > Should we consider this separately for v6.2?
> 
> Ideally I would like all kernels to support either the old or new vaddr interface.
> If iommufd + vfio compat does not make 6.2, then I prefer not to delete the old
> interface separately.
> 
> > For the remainder, the long term plan is to move to iommufd, so any new
> > feature of type1 would need equivalent support in iommufd.  Thanks,
> 
> Sure.  I will study iommufd and make a proposal.
> 
> Will you review these patches as is to give feedback on the approach?
> 
> If I show that iommufd and the vfio compat layer can support these interfaces,
> are you open to accepting these in v6.2 if iommufd is still a ways off? I see 
> iommufd in qemu-next, but not the compat layer.

What happened to this? I still haven't seen iommufd support for this?

Jason
