Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F78A51AD97
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 21:14:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242248AbiEDTS1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 15:18:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235453AbiEDTS0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 15:18:26 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2082.outbound.protection.outlook.com [40.107.92.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 792E0488A9
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 12:14:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=elkH++R8eBPd3X0kWqiVUHfF78xj66+DwNb8SYpdwik+d6tUQNpQ1F/O0Kyduv0UT6lcGft5js5hKPgS0f9y0NM94T6B3VEYmYbEJRs9WNPetLmKunFAsvlpEbm7wur62B0GXVArkzb3Y1Fa2Lg8ko79E8+WdyrdG8eUZHvk7ZI+HhIWOidCZD30Ypp12YVQ7nIYjtBUnNZoYSKg2bpIxIVNWUrFV+YI1h3kGiycPpDN/rhuQ22dHnbCSSFTLqWo4CK63dLCyCER+woD+HzFNw7spUZIJyBuGay+U/hJfaFYEtmDA/eDUBDKxD1coBnqTVV9qNI9FmXyLvvFPrlm/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oFtKhWSESbQundJDYkx1XkMkt/WkWU396DKl3zCLvuA=;
 b=I766gvZE4Sr7VU5MXRiKQKYTXFEHOUX4CNh7CMhWbNY0HYs7xaTHoXdxoD7j9GUoF+vwRYUFGRiSi4TAn9CTVGs0fOkSNOvCzoj9sueCr5qNZQ3R7ghFotDg5pu7VbG066cx4WI//KTDul0DZRBC3NB5xeo+CBjdO8R/oTgvKMLH490EIvmPWMMhl1CNKPBhainXXV1zS+WRUoZ2JuNh10PLOT1VBJyFbnY906VxfeKbfN+VJ2VQuMpEzrm9dVk+LctN4yhOR1sGv1N0+CQd7UZt3HUdXeLHusxmEFzpndcpfsgxB/UUbAiSuY3YzN7z8Ba7z46NBUetBDxhOfWGHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oFtKhWSESbQundJDYkx1XkMkt/WkWU396DKl3zCLvuA=;
 b=KEb2+OIyJYzsFqmLJ54VKa+x2188QVACHM1N66pNTCBsXHU0cprOcZ6E9Kj4QmVug0k+d8KPiiTjQEenPOt1itH0SVzvgFO6lDbtUgxn4LtQ1vsQ/zST3KO2/J5tYVfdSM2dbtyXIaVdu8HVF8Kr7kvbg0OUVx/u7ewSEyLTjPFBC+Ow64nhC/PACKQzJmz/7MToeWo1ZLFslE9/Ot1aF3qNTSu/0dR+DHKWQcbCdogqiiTVNToiW+Zi/tn3s2vexGvPEHLn549sel5YleHmD8w6TqpZ9/sv2E+vdicZ16k5Q2JuT5JS5Dguv63v+TpHMOaTb/Brhp7KeLfYP89mog==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM5PR12MB1419.namprd12.prod.outlook.com (2603:10b6:3:77::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Wed, 4 May
 2022 19:14:47 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5206.025; Wed, 4 May 2022
 19:14:47 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Eric Auger <eric.auger@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Kevin Tian <kevin.tian@intel.com>, Yi Liu <yi.l.liu@intel.com>
Subject: [PATCH v3 0/8] Remove vfio_group from the struct file facing VFIO API
Date:   Wed,  4 May 2022 16:14:38 -0300
Message-Id: <0-v3-f7729924a7ea+25e33-vfio_kvm_no_group_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR11CA0020.namprd11.prod.outlook.com
 (2603:10b6:208:23b::25) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 88d9f4f1-7d6e-4169-9738-08da2e025aad
X-MS-TrafficTypeDiagnostic: DM5PR12MB1419:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB14197A1347982BC41AF5028FC2C39@DM5PR12MB1419.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FREGfzCNrbDWMT4SwjYp9JhuIO9bQMvH2n2M/L9tf98m+KvK0t3hzvYrNsk/cBs6O8vSa282eJq1XsqmB1gCFS8lD7DmrTw5KODnMRhOABBaB0bnkaUj9Syl/Jy5gbSgxQ+co+MuN9SMtG52MbbMfsmjbha3UgjPuUrU82OZ5ZSp6pT8FHUJ+6CLaUbtKk+aw9k5z20nLm7KgnDbstBZmHhX2PxlqqLd2Cq0aZZFYEaeTfxqsrMOvc1KZPEsBh1PVfCa8J6ZUTfqo3HFa5GO+cO2PO5ArU4MXkCzmBnUrsGbNVqqFDM6BzyK2b+olgRE4IO60FpGRCWvQIxtwty6T4OBv70acs62gTZxju3+rRhH0OQ/5ds1ibX5XWDdYn9Oa2cMW2JHS9aOGgvA1FgcGmJOYPu8TyQEmAdTbixVCrgtf5bac9xp5fio9Jf2PhAPi5uZIrL0uLuYU0OipQyeb3BV6HTkYx75OwjBbhW6bPhsybqe8TosRaL4lX4XHVDlWewRZbJSGJKCTWJB5LnHDPGY3sSJD9NqqIcyDYxQlRG8sBWLvvyjZHamwq4o7Th0+lpVLc2kPONcYTJW7OPbD9qceM/+mRwmFNogWhrKR2R0pTgOdfggxzocsXV8xePL+XYsjy5aeJ9aYz4qxIgZJ4OzoXF+mhsMC76NvhwhTT3K5cwTEwMTnqviN9ugOd2l2bJnDYnGSesSkVBrQ/eCLL7UyjPl9mZlB2Vo18JfVAQAWAWOxiiFwgZ51ArtunKIvpgQ80RI6uOuGw6DYen5GVqVejaQg2m8ViPsInbQXQop0LgTVQMXfVMzE0rOjXlo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(8676002)(4326008)(66556008)(66476007)(66946007)(8936002)(110136005)(54906003)(5660300002)(6512007)(966005)(86362001)(508600001)(316002)(2906002)(2616005)(6486002)(83380400001)(36756003)(6666004)(186003)(26005)(6506007)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KZsVi4017dAQMPauwExvjJiJvFgaNhpIAYEU2crveeK2Dj+yBheGRvKsBF9u?=
 =?us-ascii?Q?aCgbRU/UxSA8YJvmcBHTLY9JbJ0WlIQKLNnK9Eek28l6vF8WNoyZsWxrgviV?=
 =?us-ascii?Q?rSGSxTwPeVTZpq/1tssYLmUOuhLsS0QfYXV74t4CzSrhiAr0g+RuOjTapYjW?=
 =?us-ascii?Q?jLbS5D9m7XTS5vqgefQ56uzp1I8rrRQQJ47lH6zsZVIXfOqSuGwCHv4YLIi6?=
 =?us-ascii?Q?hGqjMOpZIARiqp/9V/7UE8/K3cWI5jJ1JL+TE/026rscJ6pKix62/2ywkZ6J?=
 =?us-ascii?Q?FqAfzaE5walMC7XRQE3doDCgakrN/6jSJURpqEo79tuiLmLw4/F1liXD7XM9?=
 =?us-ascii?Q?7L+lcAEBKgTHhn1uRk/oOENuVSXiJedfIDEXE/ROznoB1qo8fas6RMZZzgH4?=
 =?us-ascii?Q?e5YEhhSxwWGZT7u0Co6Pidm4/r2L9lFRyCavnY5DSbosh7OFWlv0XqX7+2bh?=
 =?us-ascii?Q?3wKgKLLgY76SCi+KP6OMwWIsYVWMhrgPJVSmCyp9nirU0Jiemhr+67AjZJ2q?=
 =?us-ascii?Q?HE3jsjMPokpH2Ls3ZAGubP/xFVffheYpgfFKTyK5MSs3PtRJ4JFpz0s256ze?=
 =?us-ascii?Q?VWW5fHl5ikcKmwebT5B3M0YVfvKIHcH/Qk7g9UTwOMTJQIOqiy18eZwjVS32?=
 =?us-ascii?Q?IDOioeKU0HYvG+g6mkhcZy6lOaNfw4Do+EBjxH25A/ZiO40XuoElQWQTx5fz?=
 =?us-ascii?Q?5eMpWChoPJeq2K74q3FsbUAy9wH2fGNedTY7+yeYep7t7Qo/4CNJ4+gg5Zii?=
 =?us-ascii?Q?CxEDwxyHwdg+qsn12YJbqodu+ndg+uz90deSTHzjgDUHQbHunIUBcVKZ4Gm2?=
 =?us-ascii?Q?OhlLzZiQwyou0gMWxQ+9C02pNpwVPENAiP1+Gp+uaW+Vh3G3KNm/nT8nwWF0?=
 =?us-ascii?Q?Cu1qUHXlXw9WHt63lLZtNRPwJ0rZbW9g86Fsxt1oGVc9XWFGL8qIxDvJxuhd?=
 =?us-ascii?Q?lPGsqmzFW8xSnUWb649An9bn061uEtUniAJ6IvV2lEpoHNF4O6E1JMBiey5k?=
 =?us-ascii?Q?fGHKuvYL8X0TlV66rY585tQo7h6qXARulxJ9IC8fPP4kG7qbyFKwZA3dnaP/?=
 =?us-ascii?Q?iQ5NJwFpgYtNXAl9IhonSMX1jELv88hpoxPrcDnMMLnAcUqY82rgJuNx7i6r?=
 =?us-ascii?Q?sIZTWxfQABtSAnWKgQIP+TOzyyQG1etSzNQKFnxohx8n26OEzVazQ6xS6PdL?=
 =?us-ascii?Q?Dhzunu3P/jsFFNIcp9P3o3IcmhKIKivAENAEQ3l1RaWrBkdtMtrqIibxVZlB?=
 =?us-ascii?Q?A2UZj7HdorEQFKoTgPbJA3Bzmn8JGMIOqrWm1x8NhRp75yh3VQUffTi9C3Ou?=
 =?us-ascii?Q?hyzDX4wiNZdvyIas4JYAzifqSxay5/zpPDrY0/m8i8iuN3OHIZBzFmUJl8AA?=
 =?us-ascii?Q?+ekAgqkqXjNyK6Yf5xdHnMEALhu82Czpzte+bkPlgOZ4uggIqtSFh2qIbcBp?=
 =?us-ascii?Q?r8JxCQ2xAvSObgnkyML1iDXHgsKj6pfdUp7lNUn4fKLqvIgi0MCpsbYv2z2d?=
 =?us-ascii?Q?6/8jfnoFVE2VbWow46b92hsiloaJ22s4+m8KTl6JMpkoCgCP1w7B0x0xaLP2?=
 =?us-ascii?Q?PhVN4jlW338eALB2H1TpJAlf+C59o98Rr4l90T7DRcp/cvmInUQPyAnFcc4U?=
 =?us-ascii?Q?Q5aN9dSMCBeabT+2dTvAR+A8a68b23MOS7lnHgP1G/QZwEfO5sp10rp/gwgE?=
 =?us-ascii?Q?aA0yJSrMNSu3qHs2SFsJTBcmN4Hlki3MJBxFs80IAqzZQAtdzSNuEPbf5fTp?=
 =?us-ascii?Q?sYGaWOtSsA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88d9f4f1-7d6e-4169-9738-08da2e025aad
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 19:14:47.3734
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6sO4McZwnoWMXZuqFirwDWv2MHWcdhJVlhKqhlteeKu/JbIYgzAzEZMtM2Dfl+8H
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1419
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is the other half of removing the vfio_group from the externally
facing VFIO API.

VFIO provides an API to manipulate its struct file *'s for use by KVM and
VFIO PCI. Instead of converting the struct file into a ref counted struct
vfio_group simply use the struct file as the handle throughout the API.

Along the way some of the APIs are simplified to be more direct about what
they are trying to do with an eye to making future iommufd implementations
for all of them.

This also simplifies the container_users ref counting by not holding a
users refcount while KVM holds the group file.

Removing vfio_group from the external facing API is part of the iommufd
work to modualize and compartmentalize the VFIO container and group object
to be entirely internal to VFIO itself.

This is on github: https://github.com/jgunthorpe/linux/commits/vfio_kvm_no_group

v3:
 - Use u64_to_user_ptr() to cast attr->addr to a void __user * to avoid
   compiler warnings on 32 bit
 - Rebase on top of
   https://lore.kernel.org/all/0-v2-0f36bcf6ec1e+64d-vfio_get_from_dev_jgg@nvidia.com/
 - Update commit messages
v2: https://lore.kernel.org/r/0-v2-6a528653a750+1578a-vfio_kvm_no_group_jgg@nvidia.com
- s/filp/file/ s/filep/file/
- Drop patch to allow ppc to be compile tested
- Keep symbol_get's Christoph has an alternative approach
v1: https://lore.kernel.org/r/0-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com

Cc: Eric Auger <eric.auger@redhat.com>
Cc: Yi Liu <yi.l.liu@intel.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Jason Gunthorpe (8):
  kvm/vfio: Move KVM_DEV_VFIO_GROUP_* ioctls into functions
  kvm/vfio: Store the struct file in the kvm_vfio_group
  vfio: Change vfio_external_user_iommu_id() to vfio_file_iommu_group()
  vfio: Remove vfio_external_group_match_file()
  vfio: Change vfio_external_check_extension() to
    vfio_file_enforced_coherent()
  vfio: Change vfio_group_set_kvm() to vfio_file_set_kvm()
  kvm/vfio: Remove vfio_group from kvm
  vfio/pci: Use the struct file as the handle not the vfio_group

 drivers/vfio/pci/vfio_pci_core.c |  42 ++--
 drivers/vfio/vfio.c              | 131 +++++------
 include/linux/vfio.h             |  15 +-
 virt/kvm/vfio.c                  | 381 ++++++++++++++-----------------
 4 files changed, 262 insertions(+), 307 deletions(-)


base-commit: 0f36bcf6ec1e0c95725cdaf9cf3b0fed6f697494
-- 
2.36.0

