Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B616650BDDE
	for <lists+kvm@lfdr.de>; Fri, 22 Apr 2022 19:05:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379919AbiDVRI0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Apr 2022 13:08:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346624AbiDVRIV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Apr 2022 13:08:21 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2075.outbound.protection.outlook.com [40.107.244.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 555EE78918
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 10:05:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iY//iJa0Dawjar5gmC6HgiwcajrK+FiJqg+I8wuYEEtEsuhuHbRAsv9dhkTsRNdtEgU0AxmQeEIV8sAh11F0bYouanc6MHtKtAqFN+waPXZe7GdFQNMT+kqKcCXhUx4cCCUwOdEbohlweMFBiPL/GJx0IwirnXv5vVvOb3k9ZX7IMEt6M431jEIjUGLpSa0MA5k1vC2NMVLqoKWkI9b0SWoxcohrcxfH3addQCu4xfW84r7q8E3ziyos2cdTGgxq6S/o9OyANA3xZr16wIMpq05xrN7V3HUghZSk8UnbX1JzVDTKBlWyzmXQ9K000Wh+pqCRJpaXyHdOX2F7cU2h0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aS70Au7O360tloPrTYwvqZKq+5XgUUx7Ya2ycFLs2+E=;
 b=oEG77BRhZjd95V2t5mhqnNLvIHzgFuNxRuUNaIvg3CrX5Qh3K3U7AyrsOIg01nnuVADsFqNe5IlXVsXQU1iuNtl7aVjUjKwwKqaea/AqMPlQ5R9KdeIvezE1F2AlLSPxHREkGRVTvRmxwKbm7Fd8F6iT+3d+ocKQ7PiKFlAZz1L+TZqkhQfoTpVC5NOq2BCXfWAtNiULpDJ3+5rBwwGqsx7rtTxh9hgjvofFvKp/ARFvUwAxBoK0tBgVrYtCPrk68S2SPuCMRj/WcJQRHYzhACQjNYuZcAxW4ZsMzru0EhPzGnLc6wqCHpvyZwmHQrfvC7TW5iupAqSrlli0hoeVKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aS70Au7O360tloPrTYwvqZKq+5XgUUx7Ya2ycFLs2+E=;
 b=gP42UzRRhP+3PUxm5HvNgURnM29eJVgFUDz7nlLWJmExWSXYCPHCTgXU3o3hjBiwB5jWPJHRB//UgvZPqtlboo3gdAmWtcoWlxmTUmhzqqmjXIrSx73sZ++u582cVOZZ2nw9aSVOWiRjdOpSxHItQ4sT2EOfWtJOU3RFDpScD2jnKG8Vw3FmLS6zSVwY+JyNxDZ6q5bZC01icPArDd0+3V+FMgAAc4XKDyUcJ0M0ZUtFXie0kdveasceUVd6FCyu9XpR/vsWHSJD2FA5KAX4JG3Qk4BNqk69B9wHubGs9OpStNu5smZQvAgcamRgA3LQdiC4CpiotvMw/xQgsnN2HA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CH2PR12MB4954.namprd12.prod.outlook.com (2603:10b6:610:63::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Fri, 22 Apr
 2022 17:05:24 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5186.015; Fri, 22 Apr 2022
 17:05:24 +0000
Date:   Fri, 22 Apr 2022 14:05:23 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Kevin Tian <kevin.tian@intel.com>
Subject: Re: [PATCH v2 3/8] vfio: Change vfio_external_user_iommu_id() to
 vfio_file_iommu_group()
Message-ID: <20220422170523.GB1951132@nvidia.com>
References: <3-v2-6a528653a750+1578a-vfio_kvm_no_group_jgg@nvidia.com>
 <d9729afd-61fd-1911-ba15-ae3ed5e73f30@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d9729afd-61fd-1911-ba15-ae3ed5e73f30@intel.com>
X-ClientProxiedBy: BL1PR13CA0082.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::27) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bcd02549-619f-4143-f7a8-08da24824a85
X-MS-TrafficTypeDiagnostic: CH2PR12MB4954:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB4954ACA2A1409AF1F2F3468AC2F79@CH2PR12MB4954.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o+D9yHrfPpZGzeftjKoJBVzzg1GxDep673Au901QzCxYyJiT6CCzt0leXDlAmkT0QTHKLC2/1kT8oVf1EnZ0p30Kxvtx+qtgsK4hj1hkPn+Vx+PshssulggmQT327SEhWLQ2oB5+dFZXSjTbGosdfXdYwNcyoZ79Z6ZunXMLttApVUloVsLwirTOWiShuDeQbWN3/QntC9LX6/zPq9SzxI2o9r6xGTkE94o7089Yo8h2GPoDUNOz85tutGGPO3xbwzYMaulLmGzSfoNKzVThyMT4wyTf5B4BznWM0bumcp9psGU9w+1+kSrE+TqGVGdgeUzg2S7pVTMHz+Ieeabg0KrWB2f0scHSxa/vY/bvBB+OFK16mwi6UBIajTT1zhbrksVtAb1gPn44SOWPbf1duCNzsX4aWH3Tq6XWKKE3+qthikceuMwmM9RJ5mo6y/BbFniIhJggdftYf1GZdSc5I0H0Gcph/xVuEypdK/pRQmeSZkBYC+t1Z8HGxje9ymh+Ft7YeUG7vF+S7tqFR9FB8B5u+S7iKyINWxzD8raw9YJfhXPr0mO96aqdOlBzZDXSUmEIt9Vw4F876pMqouZw+/gbWqAqQVqbrIbH84pow4S0QWrwNPPbY5ZJ5tVv7jJbwDrkzxZSnLmCSH3zm+Q1mA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(86362001)(53546011)(6506007)(4326008)(8676002)(66556008)(26005)(508600001)(6512007)(33656002)(8936002)(5660300002)(1076003)(38100700002)(6486002)(4744005)(186003)(66476007)(66946007)(2616005)(36756003)(6916009)(54906003)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SLtN+LKCWD+YFdigwzy/UrYvi/v3/R1YjKnc6I+Wg6SKwQ25M78ROVQRDFWj?=
 =?us-ascii?Q?w7qWIAeiycLnXPn3ZFC/FJF66wh96/Eya5ZHRAq4uV6c5CV048uRziJXMP3i?=
 =?us-ascii?Q?CpIbm/7r7bf2ybw6rEDjr946BG3O7lhRY/ZtlSqO6ypnnzx0AT5oX/HS/b/f?=
 =?us-ascii?Q?eR+//WiRTO0ZELY1+N1XAVUqT57hmifLQfp3I0cvJeU2mTG5bFJvHDyVv8C7?=
 =?us-ascii?Q?6y0VfMaU+pW0JAGXhd6ELN+K2pi2QJe0HGafX3XhQ1CnFkC43Vl4ENpLHf43?=
 =?us-ascii?Q?hS8SLeKz227pom/irv67YmuLVms8Wbssp+P9iIE5HUwtibRXDQg/g2X4729Y?=
 =?us-ascii?Q?q5NBbfyHMQZKqNU74KK8cDL/GP9Sq8BsEtkaxtto0j0y6mylc4nHJ+yYjnt5?=
 =?us-ascii?Q?7v1Mm2QaS5p8ex29PW+nezwcXdNc4NxxG7tdYTT3xNtOZeHGRDW7H/OAyrEL?=
 =?us-ascii?Q?MWf/Ne5cIfE4xP6C+fjwC95Wwwyl8QbWOC2TY/VtMqbBkyqJEdtHrhNa2uJE?=
 =?us-ascii?Q?gAFWG1wOw8MX6ZpZaVWprcIz+7A+m5z34n10Zn1Z49wFJlXbirkPKMNiHR7H?=
 =?us-ascii?Q?uN86hWg8jw4glG9Ii6hKKxp3l6VB0cXvTEXMT07vYXPbPzwR0tuQ+gH7TRAr?=
 =?us-ascii?Q?8td/6/pr61Q0D6Ms6Z03mxbRNA8DQdOjlHv+YJeWSZHvrmjZ5VOw7t3GVl+f?=
 =?us-ascii?Q?eSDm5EI2yRkMpYidjLfb5RCz+DsWoxAEKuqwoeeweJIQrizC1HRaTgMl5ijE?=
 =?us-ascii?Q?BBhjr0h4ZaDND5ucbqThOXzeHlmjH4/gtywqXqCfsVuLBQUMGYJnIUJZJ5TT?=
 =?us-ascii?Q?AHbDQ9gT0EPDGMqDNsSLq0XES43ycZATFHF6LmD84x86L62RMP7Qpo4z8RD2?=
 =?us-ascii?Q?7CdlNZQ8oNi9hqA2Osey5ibeeOVNFqh4UG5droMXBklE7RJzlNWMT4KDvVZV?=
 =?us-ascii?Q?A2FZIaTJHPGYg0ffURwYtTeiQ5rva+85do5uKjAzR20CtTluJBdsGqv9jfFo?=
 =?us-ascii?Q?HVkK1VfG8F91onkBEohwh97sQbAer61TqPX8UKjBo8lI1ZJboMbrWR4FH2YA?=
 =?us-ascii?Q?L2MS/Oisu/Jtg2VGae8cOmdn3G2SMgKBSF8lgvnBLCnQl+p4uESp64Xuh+TL?=
 =?us-ascii?Q?s7z/Ucg4O1zFQ3AgdMyyF2elKeiR0fEieGzkc8TpJwInvxyTfKCUkEo3v5Ul?=
 =?us-ascii?Q?sDr3w2U/1OzbxeKL9OrumRREKJLnbRju5FdX0W+x0b4P1W95kNsdm45Y5RpF?=
 =?us-ascii?Q?bTAxLHH9TqcZLwAbzXEZtcjc9v7Ai2B0NOAIJb/+SkWXYBkc8vzYy4SshVNr?=
 =?us-ascii?Q?UfGHB3kcMtBDNx1RsKkMuwZDFQGZ7kRGe9JUSsbZhg6uwVFKzYXifv3MEbLP?=
 =?us-ascii?Q?FBRphMVUh1/rvB4KuVJTy4PpALusx2oXjJY+6o/AxE89c4tqrfMxZXPyRj06?=
 =?us-ascii?Q?3yupdecPWdpjxFszPADt6rfIElkbBraieg4gAdF5AHjs9AsEvUZaFtNc9a/S?=
 =?us-ascii?Q?CKlrZlRgWpkrwFJYxD2Q1onI2ZbFs9koO5IlBaXBeI0xn8Owg4r8FNKSKnu3?=
 =?us-ascii?Q?n3uBqk64BAAC5iKNNPzp3Nszj9EMCYgmQDBUJvrHD5TVR6YoWkoyl5DCKTnr?=
 =?us-ascii?Q?2BLJfLhMbUsqeKaL8vDxKJVzksV4g8/flLI66Rc8JHYranCd0vtqfTmzMszp?=
 =?us-ascii?Q?KIiZPtu1XEjWyhpglRUZ5MF/E9CAuFEfFkVod/5vBof/muW6reZBlmY4tYqX?=
 =?us-ascii?Q?eZxLdwkCQQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bcd02549-619f-4143-f7a8-08da24824a85
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2022 17:05:24.2550
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tC17eFzHz03rAzoQ20Siv9DwxVWDjo/v7a0Uz13leTGej+EaUGpM91twzWHvCQXs
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4954
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 21, 2022 at 10:57:06PM +0800, Yi Liu wrote:
> On 2022/4/21 03:23, Jason Gunthorpe wrote:
> > The only user wants to get a pointer to the struct iommu_group associated
> > with the VFIO group file being used.
> 
> Not native speaker, but above line is a little bit difficlut to interpret.
> 
> "What user wants is to get a pointer to the struct iommu_group associated
> with the VFIO group file being used."

How about this:

The only caller wants to get a pointer to the struct iommu_group
associated with the VFIO group file. Instead of returning the group ID
then searching sysfs for that string to get the struct iommu_group just
directly return the iommu_group pointer already held by the vfio_group
struct.

Jason
