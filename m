Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9B74325557
	for <lists+kvm@lfdr.de>; Thu, 25 Feb 2021 19:19:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231445AbhBYSTP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Feb 2021 13:19:15 -0500
Received: from mail-dm6nam11on2078.outbound.protection.outlook.com ([40.107.223.78]:15520
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230166AbhBYSTM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Feb 2021 13:19:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DUVDd/GpBWkDiuG/ZoNE15FXe9DJwPLqnrBGv+r8IL6UAy2PJlSd0o+ZD8lqtyLuyVg5HwxtqFT1xgFEYlnti08g26YKh8toEyWH9SV/6t8AUJLvB0gbBgbAtVSaY98dsIZH0yzcUast+9FHevpbZLpAE/QINcVruWN6MGsUK8ucuRGaQ8vb7JAHrHl1Tzns387CZxYcE8G4Rxb7RPcQ1bGRNWSFwGhw2/mznTDJ/FwT5CmBnk8ZUPz3ws8SsUby1FYubYdZjWK9faCPhViSBZzVI6DJTZTrUR0mOUc48/KpkaRYRI4Et8IjRpvzvrYgRT31k4T9llGit4x+VimDXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9gGDzg95XZhyKhDNkAFCXWMKwWqVBfl28tDw3rcfV8M=;
 b=Tb0zBaGS7gmzNVJVGtVOiOD9eAyBcyk6Li9iL+xpt+iz47cgOf/RNoo/7LMwJJPageM+wAFIJuXxTS+hHDbQAuXyGKxK49UDJdfZIgFCUJzogbfZhTW3EywqwdVv3rLeMlPyk6e2fakM0Fhe+gJL77et63xwZe95QM55akMgvI1taJNcmiWAjRoyHDq/n/Ugn6tLnhaaSbo6hdoNYY568Mr9yltJFXihj0RzuVL8bb6NToQ5F5n7b8T9Hv9GWwcMabHMLIVJsAZPuYojbKip4ZVHiALpR8+fg4zFRr5JAMLI7NQclhSLfRVRZQTg4t63HFvm1hrGkg1wNMVLZC+iHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9gGDzg95XZhyKhDNkAFCXWMKwWqVBfl28tDw3rcfV8M=;
 b=kF5qPiUk9U38LZfGHU1Qh+kJNx5XpCUZzNE6d7BJyTA71C40WixImEPsnVaCtoUC1rPLEwS1scwRXtIEisH8S5gNPeF9sSdc+SZbGuvGTn79gSB/c9sAeTuMQtY8VwGBJwYwv785eoeVEi9fVTMH9+jldGZ3FQ1uIAbCYczuSek=
Authentication-Results: HansenPartnership.com; dkim=none (message not signed)
 header.d=none;HansenPartnership.com; dmarc=none action=none
 header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN6PR12MB2685.namprd12.prod.outlook.com (2603:10b6:805:67::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.34; Thu, 25 Feb
 2021 18:18:18 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e%7]) with mapi id 15.20.3890.020; Thu, 25 Feb 2021
 18:18:18 +0000
Date:   Thu, 25 Feb 2021 18:18:12 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     natet@google.com, brijesh.singh@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        rientjes@google.com, seanjc@google.com, srutherford@google.com,
        thomas.lendacky@amd.com, x86@kernel.org,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        DOV MURIK <Dov.Murik1@il.ibm.com>
Subject: Re: [RFC] KVM: x86: Support KVM VMs sharing SEV context
Message-ID: <20210225181812.GA5046@ashkalra_ubuntu_server>
References: <20210224085915.28751-1-natet@google.com>
 <7cb132ce522728f7689618832a65e31e37788201.camel@HansenPartnership.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7cb132ce522728f7689618832a65e31e37788201.camel@HansenPartnership.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA9PR13CA0087.namprd13.prod.outlook.com
 (2603:10b6:806:23::32) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by SA9PR13CA0087.namprd13.prod.outlook.com (2603:10b6:806:23::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.12 via Frontend Transport; Thu, 25 Feb 2021 18:18:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d4632d10-529e-4b34-78f7-08d8d9b9b9ef
X-MS-TrafficTypeDiagnostic: SN6PR12MB2685:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB2685D4DFC42AFC31168559CE8E9E9@SN6PR12MB2685.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M1GW0P89L5KOnUia1peJgk9oNz81TWgzL0OyFp9IfTsTDQwtNbqg3qjYWPaE/UXhg603iQEJq/U6ne/+Q8DaWDByKNWa+IfHxXqlN8oreZJtIWD1RfoRId5wTTb+JXzYZHvXaqV1IQ9bkjGTEn88D7o9oXO3oAUGTf5voCVek/+OUHVmrA7DIb5+boJx49t46zwDPUTiwn9255v+qudFFk/7Y+ZQ+oziaOoPUDQK+CqShSarwulYY+eWcUajluUE5dJuy+bVDbh5bWmJ8d9/Pjm1cQnLOu07qAxTQFLFCuZ+fRQy/NAL6XfYC9EYBz/dJLEXUPMsj4r1unOI8STi0Gv3WB/nz7cd+Hkiy4Qw61sSuo/Rc9nGDe4yMZCdULeOhDmBP0XPSTHgSqtU3OYmC3GW1FHZghGEtSl7SsTtgEPJcXk8xSVpKj8ndPeDQ4jmG6uQW/Ji/Jw5rxoqnecITzuyfKPqs2Sr+Nnps2DMnqyrxOATVDcIvAFn7Zsh0iNAssnPsb0xDh+nsK7eIFBJVQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(376002)(346002)(396003)(366004)(478600001)(33716001)(7416002)(66476007)(66556008)(54906003)(9686003)(33656002)(55016002)(6496006)(316002)(66946007)(44832011)(4744005)(6666004)(5660300002)(8676002)(16526019)(186003)(86362001)(2906002)(4326008)(52116002)(6916009)(956004)(1076003)(8936002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?kZ7xk2Lmd/+JcR2b141okrYC3U9rq7lElAVjWUjAeuN0OiCLhlor/tWe8uHm?=
 =?us-ascii?Q?p96ztWstPxBoXRD5f9l7Vk0yxb23q8jPiHZh/h3hP2pyCjPD+eqB77IPZVDx?=
 =?us-ascii?Q?GldzJf80HQQU8VeVFI7EQiUQArTk3lGjGfV5AunyjIHSicYhYg1ESXoYEiI2?=
 =?us-ascii?Q?KDc8ufptn9CEynbZ6XF4WICf2fC5wQx3K4snRweN4Z1Hv+gRAxgEXB0zetlY?=
 =?us-ascii?Q?O6xmZIvw97ZmKlyDvoMO5LechRixE6TA6jq4x9PP0nmG1+8spCo8/l/2usVd?=
 =?us-ascii?Q?ttfktrTUnVOOKJ0ZObzU38WWcCv2vbtL59v941MUCn0AfESUgW7ttjknPZ23?=
 =?us-ascii?Q?FV4itzd1QRalTVp/eegJ1xmfEddsMVkCYEVw+0HAfqc5YT6reBgCep3bS0qs?=
 =?us-ascii?Q?lrii2OIaPiiz3xfCIq0c1DmCB0UJKVXMzIcusVHoIpuJRp3IeLqcJKsLU1ol?=
 =?us-ascii?Q?2xo0lOT6x/yKWFzga8aelFE+YKmykE2vMTS7untCxRsblSwFistJ7Mcgvf+X?=
 =?us-ascii?Q?Njh33MBwmbae3V/NSuWVD48CP83mtgIyV3KHZL4BfdHNe+ywpdztzhx1LLxo?=
 =?us-ascii?Q?3gnaW0dYqBygZNQFG/XxXLGh2PlxE4RPAT52eB37yWQC6XmRCXaqil8BzhV1?=
 =?us-ascii?Q?ZKaOl0HOXQ3ZbQdaIsTR0U5mZIha3vDrGEzt3WYKX4UJdNNHJBtlJ+t919jT?=
 =?us-ascii?Q?PW38f7iMnbimBQZwIm5u4yoArRkGJ+llsrEYOLO+pdIGAcEMGkKEPVOd7Nyc?=
 =?us-ascii?Q?4VSB6BSJ20ZKwbTHGRn6WMZva71ifUSbBKjgrpYXGDTnGTAoWd9HKuWtJx2p?=
 =?us-ascii?Q?JtoFpG/GRxDQYg0aSiQwrG7ABIn7U/RWNFFE/pvumHOEwZziUyY20iaObFbh?=
 =?us-ascii?Q?Z98td8/96naAR6+k0iJqK//aGCh8V5G0qQ/7z3ytOH35mkn9VCSrr1/3fOmn?=
 =?us-ascii?Q?qmBf2x5Pp5nppQ7nLrEP4rudZ03XmY7E7PEj2bn3ozvmmvLIdgW2XQZcpbK/?=
 =?us-ascii?Q?uUkU1o06yw7JIp/r5aPDjijILv8NpDPHCo+rAbET8YL4HnI870202peAIZB0?=
 =?us-ascii?Q?mNjHWZPAwmXff4tF4sLv7AQE0/h55tQAEJJLRaSNrxMneJ7AH7LcBKn4Me3/?=
 =?us-ascii?Q?FmAJ8nQJZMuTftomrjS4TGJe2oTt5fiM5jAWTKftidfSvGPNWNdZ7Fcyry6E?=
 =?us-ascii?Q?Z+0bgG8tbv2L+yctMR0fovofUvmMcVdh+lCpvsuAj/n9/IebGJ268ur5ulrz?=
 =?us-ascii?Q?5bf1G3Et3r7VgLT4VI5TVhSq0xqst3uj3B7JKk2Q590cB8EkHQhVpYsdYiWh?=
 =?us-ascii?Q?dP8u3zwWpGEZkAd1q1u3+oDW?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4632d10-529e-4b34-78f7-08d8d9b9b9ef
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2021 18:18:18.5990
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QrGWbUWgjy2xuPK8b4tODZnvM2df1J0ZlDuMDVvtq4FZVx/h4t3wZhoUychd+jKbc/vYbQAdh+alXvH/Ta9rOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2685
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>> > For additional context, we need a Migration Helper because SEV PSP
>> > migration is far too slow for our live migration on its own. Using an
>> > in-guest migrator lets us speed this up significantly.
>> 
>> We have the same problem here at IBM, hence the RFC referred to above.
>> 

I do believe that some of these alternative SEV live migration support
or Migration helper (MH) solutions will still use SEV PSP migration for 
migrating the MH itself, therefore the SEV live migration patches
(currently v10 posted upstream) still make sense and will be used.

Thanks,
Ashish
