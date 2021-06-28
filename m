Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3C33B6932
	for <lists+kvm@lfdr.de>; Mon, 28 Jun 2021 21:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236956AbhF1The (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Jun 2021 15:37:34 -0400
Received: from mail-bn8nam12on2059.outbound.protection.outlook.com ([40.107.237.59]:53281
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236885AbhF1ThM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Jun 2021 15:37:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cy9TGWYnXpiCFMenUR3vxzXx2KCTWxzyCGdqcagakdRsytvxdpRYFCOlHLHSmegfhHUMZkd8Myg4LZchpdOiPlE2UuEBoZnEFQX5HNjyCSoLFBwdVwRTtH/1oL4Zjf/T486NZCf0znSh7dTsHiv6ZxlTHad/WNTkgt0fase9tSZDvYGLg2zv5okKsmqA04kwU+2+uJW2Y9J+EaMNxfF+zzH7R+Yj/mkVTF8M19xdCiFjSFT2YkbSl2QN8BfBHgmxM7Vo3PnmyfHScceaFfYj1RD4h8eeau2ABI9GcA+UjdYW9zg2ugpIG4uwBtc/BN2eawngIuRpu3dHy+tXxbb61A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Lk0DRSoHyYSaji4cbLkv0Y8aaY9mKOaC2Ov/9wZsa4=;
 b=JWcDOOWMIYeZZWGp+bU9I137rtJPRs+XRnnVGrPlhnDLiomdJXYIv50PVi1bmXQPErzrkTOn/HLlfqMn30qRAc0gKG5hui2RJJsdnJn5eIpJdLJ/liWoIX2O1wh9HaOeqyckPQvMcoA+3bNewAmk31a7UlznXGzKcxjayLu7NzH8rwkmEwtXRTPF2Tjh6fdOfeTRz29odXzEAl+/wipidbVwpMd1qdQA1g6XkgQ54YuViUtDDe4/TCR0wZw1/RH50LinS5YLmNg6LwW+GeQducaJ0xieav8opFb/ccixkO46M1eeTGZXm0ghxjG40KfcpeTq725cuKBHqcG2NkRPdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Lk0DRSoHyYSaji4cbLkv0Y8aaY9mKOaC2Ov/9wZsa4=;
 b=R+7Tt269tkSiz4fEhgh1t/Cx/ocCe0S39gvGPNPIcK+TerEApITidWn8s2UxTkarCNFScUlXBQ3PsaRqCrWFJU1AXiQQhZmyhZ82uvtOH7ds/XjK2v8furjFd9LailI6OZ1yF61nei4UVRT2dtL0vZVRzgK32fvelMl7ea8lMKE=
Authentication-Results: alien8.de; dkim=none (message not signed)
 header.d=none;alien8.de; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN1PR12MB2415.namprd12.prod.outlook.com (2603:10b6:802:26::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18; Mon, 28 Jun
 2021 19:34:44 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::958d:2e44:518c:744c]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::958d:2e44:518c:744c%7]) with mapi id 15.20.4264.026; Mon, 28 Jun 2021
 19:34:44 +0000
Date:   Mon, 28 Jun 2021 19:34:41 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Steve Rutherford <srutherford@google.com>, pbonzini@redhat.com,
        seanjc@google.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, joro@8bytes.org, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        brijesh.singh@amd.com
Subject: Re: [PATCH v4 5/5] x86/kvm: Add guest support for detecting and
 enabling SEV Live Migration feature.
Message-ID: <20210628193441.GB23232@ashkalra_ubuntu_server>
References: <cover.1623421410.git.ashish.kalra@amd.com>
 <8c581834c77284d5b9465b3388f07fa100f9fc4e.1623421410.git.ashish.kalra@amd.com>
 <CABayD+ckOsM4+sab00SggrH3_iFaiV-7h9tHHuL1J-o6_YQVKA@mail.gmail.com>
 <YNZXPEPxv54UmzNj@zn.tnic>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YNZXPEPxv54UmzNj@zn.tnic>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0501CA0124.namprd05.prod.outlook.com
 (2603:10b6:803:42::41) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by SN4PR0501CA0124.namprd05.prod.outlook.com (2603:10b6:803:42::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.8 via Frontend Transport; Mon, 28 Jun 2021 19:34:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 13f9675e-23b8-4083-cca6-08d93a6bc7d7
X-MS-TrafficTypeDiagnostic: SN1PR12MB2415:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2415E4AA3DB33DBB59BB02F08E039@SN1PR12MB2415.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LSmdHiE6CZGGggMPiZXfQr2RM624ofXEDuJoN9LIF1IKNk0m04ICPInsVwNTEqKUwgHHkjjj+pB5WCbs1a7mGXWm5Vpz5y7CTsmqYWkX4mpHRTTwHotbNlqpvI5HRtpVwqlJoePFlfZaEBF000LP9oDJR2SG9yiK0RVwoZXypKRXKKnm9HGDKUlEXlWIGf2bd0CoCa0YSp41mF8Xk4QZMfvLJr1qHf++8r9sMgesHR+hn7d++ZfRaBDosFXw7c9sxjJotoRpLpFjtHI055BQeOqBVf0N3o1+tIWwDeDkFX2AFnvtNOceLd/031UGUovHfdaiOQW3wDpACkUUCgphhXWcpVH1oeUYsjkarG+rBytU7pFHOZG2l3PiU30kN4TUiQ/b8qwXRRP0GxG7pb5RyuvsDnCnXgySFYsiYostZEk9+XLJEKo/ovJnCtZBh0brLP3TZIgAVKtuRv4H4CjA9dc5oDz8EDGxSe73CVVN891uKzfc/azvW3PJubVnuopnfhcvBb5LlWGLc9iqzeB+0OcSmEoCFJLb4xZ0LGDBeVGVlIUizFgQQWXltS3iEHysRjkPq+x9hadm1c5wZZZ6JN9jZ+XAGy5yvZ61D9PehZiuUd0MOrbAl5Rev9ooqv1QpRF4w0dZn7IBCGB2K8ohq/XdSsOqnHY2GGgeL9bbkB9Rw51t3A8X8BmLBMj97G0yxUtY/kfq9W1nh6t3YkEwRrd57teC6oEzDA24OhvuoCTWiz9Mct/e9n2mw/bCy4TWAGUcw5f25ZUcnEAjDBBIx0QwmI2jTv5U+ElZqLZKL868Vy+05l8FASQUPJEey1HgFC784nDU2YO4a8GqCtVAAA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(376002)(366004)(39860400002)(66476007)(66556008)(316002)(66946007)(1076003)(86362001)(186003)(16526019)(26005)(8676002)(8936002)(52116002)(6496006)(38350700002)(38100700002)(956004)(5660300002)(4326008)(2906002)(33716001)(966005)(83380400001)(45080400002)(55016002)(33656002)(44832011)(478600001)(9686003)(6916009)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZXuOQucfKNKgTKioRA67s4qPG5tQEIkQIIHGEeT43+IuRrURZ52caHGzqL2R?=
 =?us-ascii?Q?4OKYhGywKZrIbCJBwTkfR7BlGvWoVVRWtaX4Ns1gndjnArXxNFH3fCaXOAZ7?=
 =?us-ascii?Q?iGa6BQDgu+VDPdbS7ytq0n7MIUC6c0mBJ+k5kC0qZTsvt+iQQw272ZfBJNCz?=
 =?us-ascii?Q?0Pq7b/mOUQAzQSY0Y13KuxSxpvhgq8vx7BEc9nXcPGpI7CboXCIl6Ivwk9eU?=
 =?us-ascii?Q?oWbX1HEbfIBcknE6asRYkV5iWi8aB1BqzmCzdq7fUTWNoOYg6U4lmAIo+mgC?=
 =?us-ascii?Q?HcGKMVQOcja+tNW8s+YT9wiIEypt2l1PBAcgWJMdsERZf0RdlzV6pA7dkuAg?=
 =?us-ascii?Q?+IfONN5f90460jA+6pbFmPoYQZJ5mUh7CW2nnoDs3O2djoI80Dq6bXVoVdww?=
 =?us-ascii?Q?nMDhOXMSbghB4NfHi0xd/4J3/Ho3xe/pKya5gRWzzYvrhIkEqKINVvTdS/Pe?=
 =?us-ascii?Q?8WVDmft1REMlxweQIS+JQCCpm0gSNf6qxuit+yx+wxqfcaw4rWCMvyZPymKz?=
 =?us-ascii?Q?UjKgI/lAWbGfrsWNuEgQMqDNghSKM8LGkYa7XS28bh2AbPYJGSvsu3R6/Eyg?=
 =?us-ascii?Q?FFAVLosoImEVVSic7wNvVqInfeKrcDI3YI6msKX1lsjL8n96d9lzGXt2qJau?=
 =?us-ascii?Q?OisKZvchJKBtaRHrgqF23gIUu1to0Is7QeYPCvK5k8BAlL5a9BnRFoFA9y4r?=
 =?us-ascii?Q?pLNByEca92OSybjzLAD6umRpWKaWK7hzFp8x6gAOKRMgQnn0spOsAfQoM4vK?=
 =?us-ascii?Q?Nl9c09JxyNvthtwyesMz8zgDfS9ST7gMZDVFyl4IntnIbIlUOlVKaGOTfS35?=
 =?us-ascii?Q?cqNlmZdeAY9PyYXM4rnYpIUJcfNz038kX3nj/smFh9Fp65kM6DKjnF1UOJ2I?=
 =?us-ascii?Q?r7Oqqp/Iq8tDKpseVycvYGy3qmSlt5LmH3LsCWYTSD9LAtI1nnunnJTSVngy?=
 =?us-ascii?Q?FQRBmf5A5zxoHblZkqdMIYXkE3JSI27Bpvy/Q4mvjnC9K663Vr6CJjkBCJBD?=
 =?us-ascii?Q?7f1Rsk1kGN/lL8MwpqHUXCCKxcvgEuKSIkiZIU+rVJ9HosYusxUNBO1lMehg?=
 =?us-ascii?Q?BtJVi6NNb6EV/Wprvd5AeHY6CkCsf1cmv3bhbp6VyzpwQvtwz5qy8XvWp0Us?=
 =?us-ascii?Q?uB8N2Tp8cYfSDAmlpL5uupYPDN41M1zoXnCTAFvnKvrN1xLHs5SszIn4tO9d?=
 =?us-ascii?Q?SRyDbo4jOOo09V1DD7kOCpN3tPyvGcJcr9kKyiopXSeInw7L+Utj2TEFGQMo?=
 =?us-ascii?Q?5Qnp13F0C1/fsb9w18tms+WvvI93sR5/DFb0ch6okeFSruVOdnyvZSxi1nVs?=
 =?us-ascii?Q?dSoOsxHzqFRH4DTzpGP9kjmf?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13f9675e-23b8-4083-cca6-08d93a6bc7d7
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2021 19:34:44.1004
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UWxDznFDkK8BWVHtawjc2qbeWn9sKYlAwWtir0FTZ8LxGzEkLLmm+pPWHvTbi1Yq0FwvF4xpkTW1VraEOOfUrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2415
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Steve,

Do you have any final thoughts on this ?

I do need to resend the patch as per Boris's review below and i want to
do that before the merge window closes. 

Thanks,
Ashish

On Sat, Jun 26, 2021 at 12:22:52AM +0200, Borislav Petkov wrote:
> On Fri, Jun 25, 2021 at 02:02:32PM -0700, Steve Rutherford wrote:
> > Boris, do you have any thoughts on the kexec aspect of this change?
> 
> I'm suspecting you're asking here the wrong guy - I think you mean
> Paolo.
> 
> But if I were to give some thoughts on this, I'd first request that this
> patch be split because it is doing a bunch of things at once.
> 
> Then, I have no clue what "kexec support for SEV Live Migration" is. So
> this whole use case would need a lot more detailed explanation of all
> the moving parts and the "why" and the "because" and so on...
> 
> But I'm no virt guy so perhaps this all makes sense to virt folks.
> 
> Oh, and there's silly stuff like
> 
> +static int __init setup_efi_kvm_sev_migration(void)
> {
> 	...
> 	return true;
> }
> 
> returning a bool but that's minor.
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fpeople.kernel.org%2Ftglx%2Fnotes-about-netiquette&amp;data=04%7C01%7CAshish.Kalra%40amd.com%7Cfca523e6b5b64a467b0408d93827ccc1%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637602565894090530%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=JmqtrGxhzgVczPYWdCKEyRIxDDRcDI2Q%2FI83j2dxhGE%3D&amp;reserved=0
