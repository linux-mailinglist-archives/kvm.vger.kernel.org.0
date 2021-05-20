Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E820638B412
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 18:13:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233646AbhETQOd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 12:14:33 -0400
Received: from mail-mw2nam10on2080.outbound.protection.outlook.com ([40.107.94.80]:5960
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231927AbhETQOc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 May 2021 12:14:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S1jnYzj+cfWwOh1KMBqwii8yJWn8SOrJMaryeKWyGq8ggKsK/PRWRwKDCC7I92xcEWEmRASlyweZFAkKHK25agWsnc+NANlBIyuOTC8VHnIcjKxvck8HPxCWKUVVWPEAz0vIiBP3Xcr+MCEVBWzAhH2rS36sO6tZgYgwVxwXaKrUBjsNZq2Brk9FmB9a4m96VQimp9v/Ld3W/Dzp5eo9mNLcmErk3vuJlktu5f7XoWZnoPdOMtXYTQVWnFfjqX9adLTN5DsQ+9w96pLalWgT08rOrCgqhp/f3fwt4n/MqOaOd6JnaXxZ/4XlNOGBb+B+1r6TgaRyN/Qi2DFQkzoQ3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zid42nEi3BgCAhyf9Kn6wYnQ6bPOpRs/h9iXHu5iP/w=;
 b=nF/MtGHrhXdDNHg6ZIguVxwonlMr3ooj/TwB7d3HJW02pk+TySTMURyPbammcXK8WdDK6xlGJR/opK8qV6ze16AHiUdAok3bfzsK2UR3UQjR7JpKckmZoSY438dHXDWx1Ujj5ni1ZuFUtQsSkTLgfcENrIHczqN6itQ2abtpOCAynNBgLLHN36xwOqhxfrU3lANaumE4HvvFXb7QnmMuSGcZ4kLczVIk04M21nc7oRfJtUrJnuOgfB3C0xrmYFpJXqggu2kgnMS4un6PoY+9YFe4/gPIenhuo/9OPphJ4pR0J53/qU0fx8Z9MjbjOdPRWyyMjLaVxLj3lL8kIUjwjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zid42nEi3BgCAhyf9Kn6wYnQ6bPOpRs/h9iXHu5iP/w=;
 b=mmXFcxkKmmQigJooDmWczeHACJ+vjxiUs42y6RwBLr6pVYUQsXlyq11sHtAW56GnlFojJi9mhVtQXf6BOm++fcwkuxsSPN5Ygb1CuyMgXJHf0aiUpk/pJ+qTlrukQM+lKpySZS6kG28ShKZFJdht2ukfYkRA6y7kvBWWXhNmzh4Luk5WcvqGDYDdB0NwowmOi3AyPyCxU6earC8FxLFzjf+yDC4NbxnW20x4ApnWIrpgU2nJDIk4j0VX+258VCC+5lWMZ2ukMOvLTxbNtyZWY5OCSfJP5GUqAia8e0/CKjMZqqDCjiV8heYq9+dWQStfkAwaMTUpVk1L55poN7/cwA==
Received: from DS7PR03CA0099.namprd03.prod.outlook.com (2603:10b6:5:3b7::14)
 by BY5PR12MB3748.namprd12.prod.outlook.com (2603:10b6:a03:1ad::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.29; Thu, 20 May
 2021 16:13:10 +0000
Received: from DM6NAM11FT059.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b7:cafe::ca) by DS7PR03CA0099.outlook.office365.com
 (2603:10b6:5:3b7::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.33 via Frontend
 Transport; Thu, 20 May 2021 16:13:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT059.mail.protection.outlook.com (10.13.172.92) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Thu, 20 May 2021 16:13:09 +0000
Received: from [172.27.15.55] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 20 May
 2021 16:13:07 +0000
Subject: Re: [PATCH 1/1] vfio/pci: Fix error return code in vfio_ecap_init()
To:     Zhen Lei <thunder.leizhen@huawei.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm <kvm@vger.kernel.org>
References: <20210515020458.6771-1-thunder.leizhen@huawei.com>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <b72a2be8-a46f-0854-a29d-264c806ba953@nvidia.com>
Date:   Thu, 20 May 2021 19:13:04 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210515020458.6771-1-thunder.leizhen@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2e8cc8ad-44eb-48ce-7d33-08d91baa2934
X-MS-TrafficTypeDiagnostic: BY5PR12MB3748:
X-Microsoft-Antispam-PRVS: <BY5PR12MB374880F49FFF49393FA27675DE2A9@BY5PR12MB3748.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1388;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M3AP7dgtqf0OlcWNXe0PXZV3kjQF12Mx9QmSUGB1tFPo1GStL1ClLNBcMIEkDV+D2UeAHhO1aUC+jslY/uKfBMFoNQpT/dRo6gf1hXWToFHZCqvCTjUNlQanvfNlqeVVARpbTi2xfKWmmNWx0EvPklpwK1VzGjMaL9CYrSeF8yz0eBKuarPAvyzASSohvSotuzy+4mJ05dVZkR10mU8EUjxbjNjIbIJ6v1dM+eFLN90taCzD1uKM9daC4Etlg1q3Uy20Z/F1zYg8qtLRE1gEH0gGqB+xDBTKPA52ouvl2H3Pci5dQ92OcHM0o22xhF9eVTGaa4msTBISlGyZblXBPtCd4fTW/3onTdiO8J1ASsCT/V8BVWQSXay6hVIgIAosQCI4mrKdbg9qqQ70D5J6SWePcbpupj0B0D8JpxehtG2rnMZnpNZYQvHDIC5HRhrWN2hteUB5v9U4m2NsnkO5YrnA72OpwJUPDNLP72HRW6euCj7+b18utVetifropA99ssdExDw+2R+EGvOoaW3DUoumtUPr8gv+MtMrRABmnT3ucJlEogqclbLsrmHnu2ylv0Xc3kBD8j9Ue+VTSDbSJ5YMaEGb2OF1qhy+Eq+U/XAWBoW3kKLr8iRZ1bRoX832iAcwyqYoNJ72OokhrT3kHwlKeuuIhvLCsjHLy9LABduV2QOy3IsjoaBcu76J4aPX
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(346002)(39860400002)(46966006)(36840700001)(6666004)(86362001)(478600001)(31686004)(47076005)(31696002)(36860700001)(110136005)(426003)(83380400001)(2906002)(26005)(82310400003)(82740400003)(16526019)(186003)(36756003)(70206006)(70586007)(356005)(5660300002)(2616005)(53546011)(4744005)(16576012)(336012)(316002)(36906005)(8936002)(8676002)(7636003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2021 16:13:09.8192
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e8cc8ad-44eb-48ce-7d33-08d91baa2934
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT059.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3748
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/15/2021 5:04 AM, Zhen Lei wrote:
> The error code returned from vfio_ext_cap_len() is stored in 'len', not
> in 'ret'.
>
> Fixes: 89e1f7d4c66d ("vfio: Add PCI device driver")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
> ---
>   drivers/vfio/pci/vfio_pci_config.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
> index d57f037f65b85d4..70e28efbc51f80e 100644
> --- a/drivers/vfio/pci/vfio_pci_config.c
> +++ b/drivers/vfio/pci/vfio_pci_config.c
> @@ -1581,7 +1581,7 @@ static int vfio_ecap_init(struct vfio_pci_device *vdev)
>   			if (len == 0xFF) {
>   				len = vfio_ext_cap_len(vdev, ecap, epos);
>   				if (len < 0)
> -					return ret;
> +					return len;
>   			}
>   		}

Looks good,

Reviewed-by: Max Gurtovoy <mgurtovoy@nvidia.com>


>   
