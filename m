Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B36443C71BA
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 16:01:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236879AbhGMOEQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 10:04:16 -0400
Received: from mail-mw2nam10on2065.outbound.protection.outlook.com ([40.107.94.65]:14831
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236859AbhGMOEO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 10:04:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tp8Qq/lcJ7aRFKh+cqvZj594sbJyL99LY2ICmsHBjZvuLjHmN0/3JTGg6t7W6NMVay0OtF1uK5bGJOrDJYaIWunucBO5qQv/lP+txfnD0wQ8Tpqsm9LuFuqRrjLN0gcm0u+NDRjqf46AUEj2H4QMybHrcsSehyzUAgygOUtbExsp+dpysTYG1WWAQtDKTXh3jDMQ/BiJ5keP1PNuGZfRBN3DqmveIHh9G9dyFq/v7muOP8JZRpP4514FB/v798Uq2di0BindwLeiw2yjiMwVmj7ptSHgTk8/X0RdADyh6+jAu7wdJLufQf+RUHpsHZKzD7oPmooLkUvk3koQMt+PsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aagtgKCbUAA9ArPKom/w6aT2DzC2JZTuEGc9d0etckc=;
 b=JLxzyxW1a/ILEdpdrWvRAeNxsq5+J+mDsuZwl9pRiCDnPNFFjcNiNYHkiEl2nDGHZlJLQeStNUZWTHEi9MkhMlwGTbl+jwYckbmceVD2bpcMXzxsLGtz/vvg7xJ29hwS925tk+M81IrEFyrtARoO2tPXGmLnEvZQfQ0RuAvdpJYgP6bsbhcBroxu+0ynUtSuBpXbiFq59Qq71nUSVqFcZ9XwEua76s7kd6/UccyjhvEv461jCfTDEhdYWVTV/s218QdaWlXYaQQNDaSrtX1EzE09l6P7Vr1ctqxxyPebHP3cO2Er9z6DjK6VrvQbuUeAfYzyusAu21Pd0bCCcczqBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aagtgKCbUAA9ArPKom/w6aT2DzC2JZTuEGc9d0etckc=;
 b=lZY79mUhv41FKe7VQ0nnnoLmzc8oQmZ5NS8/ADe3UXo3SPLSM38aNAiX1YgRknCbdMQVoKlNjoxFSmNcVOO0XSiCs//IeD/Zf3sVlwRPNM+qEmCctTe2v/KxEhCd/B2w8M3ErRCzMB9EonYoQ+e5PcBI6Z0njSJQzrXK6yEU9C0=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4495.namprd12.prod.outlook.com (2603:10b6:806:70::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.22; Tue, 13 Jul
 2021 14:01:22 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::a8a9:2aac:4fd1:88fa]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::a8a9:2aac:4fd1:88fa%3]) with mapi id 15.20.4308.027; Tue, 13 Jul 2021
 14:01:22 +0000
Cc:     brijesh.singh@amd.com, Connor Kuehl <ckuehl@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        kvm@vger.kernel.org, Michael Roth <michael.roth@amd.com>,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: Re: [RFC PATCH 0/6] Add AMD Secure Nested Paging (SEV-SNP) support
To:     Dov Murik <dovmurik@linux.ibm.com>, qemu-devel@nongnu.org
References: <20210709215550.32496-1-brijesh.singh@amd.com>
 <e68a9760-121f-72ee-f8ae-193b92bde403@linux.ibm.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <80b92ee9-97d8-76f2-8859-06e61fe10f71@amd.com>
Date:   Tue, 13 Jul 2021 09:01:21 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <e68a9760-121f-72ee-f8ae-193b92bde403@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN1PR12CA0058.namprd12.prod.outlook.com
 (2603:10b6:802:20::29) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.95] (165.204.77.1) by SN1PR12CA0058.namprd12.prod.outlook.com (2603:10b6:802:20::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend Transport; Tue, 13 Jul 2021 14:01:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 871aad80-c8bd-4a78-6e19-08d94606b1fd
X-MS-TrafficTypeDiagnostic: SA0PR12MB4495:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4495E1746A6767203171158DE5149@SA0PR12MB4495.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0X+eyppVFnmBE9n5jP3fVbnlZ9nnbM+WEIpO8As1dz7fn6noEROj2+Co9ioHMbdw5OHeWfiIg+cVphHa/ikTKY6jxSdQCUM9P1JoEd9FlIg2ni+We8LJmhXChKT6GshzoeGrnYD6+7NwJVtx9wuuGHFMcY7T2u68zM0H0xKh9AAffLBHAzVaVZ0ytxLU/yI/BVwj1LKvsVMyC6QQiEg9fkOxNp3kJWKTgScG6AlKXi3WMq6Hr97mfX400ja5lV0DLHnRb/1ygQbgeWRMzR/cn2OLwo09jGN0bDcPeRyfsdGXLQZRR7njdE6xbxLzmOXG8EahY93Gvi/0fLHP43akqfwc9Y5IirOYdS/LytP5A+Ae2xAE0HWjAWdfm2VXBsgJcYEJC2tls3AXH4EvasVIE3OntniwJjoedb5B3eo11acSQb9k/lLP1pWCYqHF6POk3/IsMV1EE+6N6GDdabvRDS0b8qXf8qa9vhMtaXlKZuhMi0mM91YRmGQxIQIKtxmw5l4/WgBp5zWTeA4w8Ic34wMfes38HjEERbQl5K4Z0AuAD4Y6A+cyM025lCbI+MrekZcCzbQOtE+NdSVDSuTeAKhvxmdcLXCP6TnCQIYrUILtg6VDdNfyFyRUcIHXgnC/DYYNi9CmvSgi08wmgmVwPmKGdbw6tupDeZByqbuNAjqzbWowpxoKG0/huoIdUsSGVAW8qdxJM1EXOAfgtbtX4i3WM1As6WhUkTvPb3GnlVpZysN3mh4mv+oyPYuL0Zl5tPHnEN1VOV6YYJLNFLm7DA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(39860400002)(396003)(136003)(366004)(52116002)(66476007)(66946007)(38350700002)(66556008)(2906002)(478600001)(2616005)(8676002)(26005)(7416002)(5660300002)(8936002)(6486002)(44832011)(4326008)(38100700002)(31696002)(186003)(36756003)(316002)(86362001)(31686004)(16576012)(956004)(4744005)(54906003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UlFrais1K3VDZnNJdFlPaFJPU05ueWxDdVRYS1J1dlU4RVJMdXRIQVpLYmd4?=
 =?utf-8?B?cGRGMy8ydFQzcllHaHZFeU9jVXA2WFhWWEVsSXJEQ1J1dnpmelMrSXFjYWZz?=
 =?utf-8?B?T3NncjFWcm1nYXovNWRzak53ZGt6c25DQ2lBOU5xKzJOa0FmQWlxMHltMjJL?=
 =?utf-8?B?RkQ5dGxIbzIxUXRPcnBGK3F5NHZ0RVE2QWs5MXN3dHE2MGQrK2U5UnlBSXU2?=
 =?utf-8?B?WGsyQUFHQVlZRnVNRkcrWERzbGxZWWtNOFY0ekVZbTNhM0F0MEFzcW90MEd4?=
 =?utf-8?B?SS9zWllGaUxwL244RlZJTDFaR3ZhMlpncnNBeTZCM1RZclZNdmJPbm1VTEx5?=
 =?utf-8?B?cDlpcjJxcmJTRVZycVN2R2E0TjJ3emV3Uk9mVzBjdEs5WDJ5YnFuczRlN1lj?=
 =?utf-8?B?MlpueHp0NkN1QUtFQTV0d2VFalc0R1dQT2UzY2JBdHd3aDJKU0I5aDJ3VzdL?=
 =?utf-8?B?RjhXQ09iNGpNbFJUT2Y0WlFBWWpNMnRpRGU3c0U4MnhlWGt3R2Fxa3R5YmM3?=
 =?utf-8?B?SEtsekdGZVhDVXd1Yy9TQ2NqWTBBaE1Ua3lUajVJN2hYbmc2Z09YalNXVHNO?=
 =?utf-8?B?OW1YUndEM3FmekxOOHU5b2c1NFFmMm1Oa21TM21XZEtpN2krSUNsVlFjdFFo?=
 =?utf-8?B?ZG1pTDliYUxURWRGQVJkcjBIcjRNcFZ3MS9JWEFSTFh3V3R5bkFJWEdtT3dX?=
 =?utf-8?B?cFdGZVpkcUFmSGY3VW5TTUdqQW5JZW5ReVFEQTBIaVJaRjIvaC8vWWJCLy83?=
 =?utf-8?B?Z1dTbDdGQ0hoQmtwZHlBUlo2aUVyM2lZSE9JZ0RqSC9FNVBRSlp3NE9kUm14?=
 =?utf-8?B?c1h3dXlTdzk5Q21TTkV6MlUvRUw2WWczdjRhSHBXSmpiMXRQZXFabzROQXE4?=
 =?utf-8?B?WlpYQlZaUndVd3BoMWQyNGdIZDU2VEpUam1UM2hkdlQ5WXBzaVNPeUphZEE2?=
 =?utf-8?B?RVVNdFhTY01QVlZiYVIwYWF3VGxkOGtkTkVHMVdOSGNLb1VDMncwRFc1N0tt?=
 =?utf-8?B?ajZpNTVZdis0TGN4bXd1MmVpYnpUZVE1ZzRuRExJUzBEY2tqRmdYbmpDTXRq?=
 =?utf-8?B?MGdjTFk0RVVwZ3FqTWw4S1g5dE1iVnlzN0JXUnp3WnRzUCt0NFA3d01aYVBI?=
 =?utf-8?B?V2taSjNMdmFnMEY2cUU1bktFbzJoaUpZVTNicXlzTThGL0xDelMreVMrNHM5?=
 =?utf-8?B?SUVVUGYyZENCbHZQOXhyb0N4RkVIT3NHOGZKQm1uL0IxY2lDS05aU3c0NElT?=
 =?utf-8?B?VjJYVi9ObW95M3JzTmtFcElIUHlVKytCTUprakJQR2MyUnZiajJjbmNHOWN1?=
 =?utf-8?B?UlRGTzFYc3ZadWw5L0JEQUFUVXNtQzdnTFR6L0pvK3QrRFRPc0Z1RFVuUVR1?=
 =?utf-8?B?UUU0bTdIMUViM0V2SFgvRTh5cVdMdFlWVlJNZDN0QU9RekN1TlNxenExaWhX?=
 =?utf-8?B?VndsMXNteUVXVVZ6ZzRiOFYwSklLYmlvK0FaRnRYTDJ5K1llRjJSZGhVdzd6?=
 =?utf-8?B?ZjV0TUFjN0o2ZFNUSzUwUzd5MytaUmc5Y0ppM2RYVmZmc0ovYytGMDBqVEZP?=
 =?utf-8?B?bWNMamdEN2tpZFV4cVpHTVVzdjJseDBQSVpoYldRRWVwaWJSWHNuVUtnRVNi?=
 =?utf-8?B?TEJPUk5PUWo0d0RiTU00VUF5dUxGZHhZb1o4RDEzWlQ5b24rWlNtQk10dXBk?=
 =?utf-8?B?S29jYzZjaDdpVVFLUXBsUW5SSXFnZEM2YktidnA5WkhsajJXS2tNN3lodnFL?=
 =?utf-8?Q?Alhn6txClURIoT1vSrXPlHZeKNzXOrn3iF/wFW7?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 871aad80-c8bd-4a78-6e19-08d94606b1fd
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2021 14:01:22.1568
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ia3r3Z9DWwGB/J1/jW8rtpoGLRsXZGPB+CO86zjaW7qFZ1lm8cwp5MbfTPxXQ2o9yr4600W5aF5E7d/RusyfLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4495
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/13/21 3:05 AM, Dov Murik wrote:>
> Particularly confusing is the `policy` attribute which is only relevant
> for SEV / SEV-ES, while there's a new `snp.policy` attribute for SNP...
> Maybe the irrelevant attributes should not be added to the tree when not
> in SNP.

The policy fields are also applicable to the SNP. The main difference are:

- in SEV/SEV-ES the policy is 32-bit compare to 64-bit value in SEV-SNP. 
However, for SEV-SNP spec uses lower 32-bit value and higher bits are 
marked reserved.

- the bit field meaning are different

Based on this, we can introduce a new filed 'snp-policy'.

-Brijesh
