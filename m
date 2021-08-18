Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F7593F01A7
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 12:31:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233576AbhHRKc1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 06:32:27 -0400
Received: from mail-bn1nam07on2055.outbound.protection.outlook.com ([40.107.212.55]:31555
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230424AbhHRKc0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Aug 2021 06:32:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jy6bBU/5mbayZMtme04mMQSb6pGt7qON/ua7B/xALMML0EiFZDSFuoYS8dfFiI0Ov3m0+od3Hy1mR9fB0R9zlA7NU92ZuzcJjY2qNEOUPzseqwvCyEGLGoWQiha7E5osuTSNkYQHXj8X6Mq4rNKfPD5ulU+h4eksSmYIvVTU/GpXhYVgPXke8LMtxa1e4BsceFO9xcY+I5V6//s4quDJxkIV/A623jgJxQjZL0XN6srNwx5hcxLE7N9iODXcdLyyPsvCCsvBV4by/LCH+0uMOVqAxZt1g7V7nBkohaXwdaJnEQ/5QMa7uNduBpak7VJpxLv0sa8uqFOkCZ2DAyl3kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n/G19iFaEWOoaqlznXhU0x/LsP1wXT/T0iifTOKlgNY=;
 b=i2i6oJfPn+QK1YPNN4jTPs//GchmiQdAjoKPR0tvQy0s2Dm/Y2KKjjG/h05DXNgw65S6lsMAAf9XCGWl/C06BTBQ6VpPO0U3y/TY+dGk9nTMKKsTWwWy2/6UhkmfnHCAnGt5zdpg+DWlnfY13MCMIXs7e3zvedJboLW5CznsI2UNbo1RVAZ1Zy9OgfuqTW1M9/eAfxrW0T9cxJ0Ne+UqLaQugWfEeZJjkRwA6+Y7w90n2eNZsaWDJYfnzIKTbATY1vB0o63lWB9pAfr18x4VSqHxxZXcndZM1WlBcckAUgTYHP6x8gWbwbxAezIEH+weuz1/lF9Ps8BslR8HyYmXyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n/G19iFaEWOoaqlznXhU0x/LsP1wXT/T0iifTOKlgNY=;
 b=nyvqVh6BnXzaJmxJ9qOPWdWEqkHa/nw/7PEQ3FuI/xxk1z1ZDLWsjefCrOX31yt3Y5Tk9de/RgCe5UW57UKOQFCE+EslDPQIqjAEYv81JEREiWrw+6dm3dUflyQWJqvDtAZE0gXSmnFWkOb+N3syjlP72qBhGW2r0iZuJxEdl9Y=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4429.namprd12.prod.outlook.com (2603:10b6:806:73::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.16; Wed, 18 Aug
 2021 10:31:49 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::491e:2642:bae2:8b73]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::491e:2642:bae2:8b73%7]) with mapi id 15.20.4415.024; Wed, 18 Aug 2021
 10:31:49 +0000
Date:   Wed, 18 Aug 2021 10:31:47 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     qemu-devel@nongnu.org, thomas.lendacky@amd.com,
        brijesh.singh@amd.com, ehabkost@redhat.com, mst@redhat.com,
        richard.henderson@linaro.org, jejb@linux.ibm.com, tobin@ibm.com,
        dovmurik@linux.vnet.ibm.com, frankeh@us.ibm.com,
        dgilbert@redhat.com, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 00/13] Add support for Mirror VM.
Message-ID: <20210818103147.GB31834@ashkalra_ubuntu_server>
References: <cover.1629118207.git.ashish.kalra@amd.com>
 <fb737cf0-3d96-173f-333b-876dfd59d32b@redhat.com>
 <20210816144413.GA29881@ashkalra_ubuntu_server>
 <b25a1cf9-5675-99da-7dd6-302b04cc7bbc@redhat.com>
 <20210816151349.GA29903@ashkalra_ubuntu_server>
 <f7cf142b-02e4-5c87-3102-f3acd8b07288@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f7cf142b-02e4-5c87-3102-f3acd8b07288@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: SN6PR04CA0077.namprd04.prod.outlook.com
 (2603:10b6:805:f2::18) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by SN6PR04CA0077.namprd04.prod.outlook.com (2603:10b6:805:f2::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Wed, 18 Aug 2021 10:31:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 609ffaba-679e-494c-4096-08d9623362c2
X-MS-TrafficTypeDiagnostic: SA0PR12MB4429:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4429DEAC5F58C4CB2B70CE678EFF9@SA0PR12MB4429.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8JmlOPiC89HN7HHZden0cjFACwIiWY328Tx72wEbmhpldCPrwfCHi6tZha+FHiuShqd7q9wG00V+kU3MjASvgg6+5qxePSHe/OKNnKSxgUG4pa5NEeAloIW9XGApXTQVrl50xBWB6+hNqBr5Ye9uSXwz2Wii922+ZNOQWmURYaDXmekq5JBlxbADINd626wafpON0cpRcxOnAQjvCll4IDS0BONfXJjRh2sCJ6JWRo9PahNM48d3ydrNBjBZrHZcx9w5qhAOQYnyCISpCQrbzJoa+swskGbkRQExVofPAoE/DdXCATx/HVfuIfSjPLV5POMi09ZuiPfbHv6pfsISSsE0T8m/GykQ71R/XNFU45+96uMoRP4Qu2z4NGEjMsz4co8k7AK6kLdlvm7bOQ0ccWDUSJUI5tJX18pcK/mCshNLbIp2zFYJvWk68XCMywVgILBxBNi+gCEu585TFcQR1xW/gcPLkoK3scmK71vVCQtDj9PIH3JZx69cnoBCexsP3Lhdyyd1Hhfh7P3BoU7U+iZMvNPN3vNsA6p3oCfwAOvKdEB/eLom0aLGY2+ntIvecx1P5ywg4cxL/VZeX27Um3H/Bc01XTqXBMAty90BWcIH962X0n2fD4EVIC4z5TSphrt671SWjbCeavd9C9H8fuFKYbMvd+B22tKyJoq2epDh7g0cHkGlWU/saH+4blo3m2g3FIzb+XUexITmaoGhCw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(39860400002)(366004)(376002)(346002)(478600001)(33656002)(33716001)(8676002)(956004)(4326008)(38350700002)(38100700002)(1076003)(52116002)(8936002)(6496006)(44832011)(7416002)(9686003)(55016002)(53546011)(5660300002)(6916009)(186003)(26005)(86362001)(2906002)(66946007)(83380400001)(66476007)(66556008)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Sh8olur/OEsiSUlpKJ9BH1UIhW1VlW52XErVqx8hnj092Zj/aHSsQaGTqO/l?=
 =?us-ascii?Q?RutmD3fjEo311gJmJwPH9mBjNhH5OaxyL4bTl6XrMbm7zuT9kW6BiRKZJ+8p?=
 =?us-ascii?Q?A6e+knZFjnsCPOyiToqRI/dIe7YSvxYL/ZRxYJfSqxRcOsSJEu8NBFCk3NZB?=
 =?us-ascii?Q?InW2UmkmiL649LSylqbvGiQb/0gXK2qchwbvusgdVidFSKlcHXpQgBVOwiRn?=
 =?us-ascii?Q?nxDd591xFpBpDX6261xmpfb1lmYvYpPjyFxOJxOCJ9gtHqS2wTmK4E/7aJ06?=
 =?us-ascii?Q?d3QJ4oXMZbm4C+7VrjNJ7nTrwq/oTVqXIghZqNMeZKN8tZtNo8wLgZDzl436?=
 =?us-ascii?Q?i7+LzNsSWXgFxpwkVLiYj9eRQtEsQMgBzjOyoUyG/xWOvshOAfljECOMMbrW?=
 =?us-ascii?Q?X/Jo0dalmWqbIgflUIaa0HaCCk1S7HVZdx83bOhiAZnTXAm6Ad1T0D2ziz82?=
 =?us-ascii?Q?Q1pnOdnZhVzEjFTUIg3ZFv4u4GoHV/iqDzjVNgQH169gF+gZGEg2XXkfHl6Z?=
 =?us-ascii?Q?It4Q8M7yJ/AuL7bbDJfVrPLLepxI1YgudTb47JPaSirnUKeDv3j2xNXUAMdn?=
 =?us-ascii?Q?eS2iAo70wU6aYdlDRX+TYFm0+moEVcDhQOKY8upbBfIPAyBbujXTfz5547sT?=
 =?us-ascii?Q?KHYZViLglaeQoSUp1NlwKa3xCFvBV0IwgcRstoL6TfpUsNawuuyyDQWfbp5r?=
 =?us-ascii?Q?++u1D5d8YY/z/18k/MPjbPvHvhJvBIL4GqgIqP6jOM0AZBKT1SHXicmeq+mU?=
 =?us-ascii?Q?Mn9KN3k6Wz5dfYky1t9UAFFFEh1qJOPrsIPIuRklyguqGL+yNk6sB5wsyDzB?=
 =?us-ascii?Q?AzWwtF12bYQfkT8HgWTHHshc6yb/U8v0nblKQlOwg/6o6X/KzxVib8GXGKaL?=
 =?us-ascii?Q?appLoQaUwvHMNHBINcBIlhMeMPZ9LS++fOhxpIYuQ01iciy4NSmdJEfD7tvv?=
 =?us-ascii?Q?nAv3AYZpS1hRQUNt7FMyoHfSsdzQcmN4E34Tt2DdkZpKBmndsWgdArwyt1RV?=
 =?us-ascii?Q?tmTCo8zAj7yhcoJYskYxHcxQlOezHQNFGHcyqVZwfffGUQFGmIewitFiTiRp?=
 =?us-ascii?Q?Lpa6aSsBgDlcr+bCtyeH9pnoXOjZpjTBp9XzxXwiOZ+vKumMzIYEmfKbSIDn?=
 =?us-ascii?Q?q68RgFRHKD72GhT44psWc4FkqAWfeCQF6KJ/Z/N8H5sJ0fK+jfY/4rQL5cP/?=
 =?us-ascii?Q?9BpUkzZieHa8lISLXbqvFpTV1i+YJlnBaic3UvxXQdj8lZAUzWeENMgiH3Lt?=
 =?us-ascii?Q?Bn6+icU5HrcJ7uqEtB1phgzBDzLsy8l/kJCwnohottryfp2591/85pd9gzpa?=
 =?us-ascii?Q?puXeoiobCKBhHux7Ply1EGje?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 609ffaba-679e-494c-4096-08d9623362c2
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2021 10:31:49.1296
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0sGrD9ITQPbCLEePUplC2rSBA6/nPc/apSj1GD/xTo7OcY88MLGeEYNANSpKrS5B4TnMyYvhh6DZD1A+MPk7Sg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4429
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Paolo,

On Mon, Aug 16, 2021 at 05:38:55PM +0200, Paolo Bonzini wrote:
> On 16/08/21 17:13, Ashish Kalra wrote:
> > > > I think that once the mirror VM starts booting and running the UEFI
> > > > code, it might be only during the PEI or DXE phase where it will
> > > > start actually running the MH code, so mirror VM probably still need
> > > > to handles KVM_EXIT_IO when SEC phase does I/O, I can see PIC
> > > > accesses and Debug Agent initialization stuff in SEC startup code.
> > > That may be a design of the migration helper code that you were working
> > > with, but it's not necessary.
> > > 
> > Actually my comments are about a more generic MH code.
> 
> I don't think that would be a good idea; designing QEMU's migration helper
> interface to be as constrained as possible is a good thing.  The migration
> helper is extremely security sensitive code, so it should not expose itself
> to the attack surface of the whole of QEMU.
> 
> 
One question i have here, is that where exactly will the MH code exist
in QEMU ?

I assume it will be only x86 platform specific code, we probably will
never support it on other platforms ?

So it will probably exist in hw/i386, something similar to "microvm"
support and using the same TYPE_X86_MACHINE ?

Also if we are not going to use the existing KVM support code and
adding some duplicate KVM interface code, do we need to interface with
this added KVM code via the QEMU accelerator framework, or simply invoke
this KVM code statically ?

Thanks,
Ashish
