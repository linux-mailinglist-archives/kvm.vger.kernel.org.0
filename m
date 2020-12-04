Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFA6D2CF652
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 22:41:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727853AbgLDVjw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Dec 2020 16:39:52 -0500
Received: from mail-bn8nam12on2058.outbound.protection.outlook.com ([40.107.237.58]:29792
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726534AbgLDVjw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Dec 2020 16:39:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nl4Ig8+IAF3AIbPHrFlqHyYWnT50SczRDdtRsKqyC0sZRczN2/2OCwbWLj34R/PFLDGRWHnEztsFLPZOLu+Iimwwp0JhMrlFKu19xjGB2aTdS9LQH5f66HSBZWDtmeo7mtl9kz99clWoiIkouN0Ippf7fcKoK+YfzHQW75QkjiJz58NfH/17EtckqLM1Y5NZmtKoJ8b3eC1HCmpZ7AHH+OjUDinSU5BeaCbV7RdqDSvVok43qBF9/5Eto/jG9qzqsJHeMOad6juJXt3fJigvRaFLQZ4ie0wd+PwfH9fomj4PQlfPFm1t0W4ZrOGK5Uf4hSZ96gNskARJ9PxFpQAWKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bECNJvu/9KyTMB3N0hVwlBJV48d9S2lXGuROiqRtFDQ=;
 b=d+n63DNdHqaDpZ9EDph30eEmTvnw7I06ccdRsHg4PdbPu/QRq5FuzkSDxPoUlFbwX+lcHuuijIq+FrtTqtNBuH7MZAj0ltUz4Av8mbmTNZ4qNKUUN3zyyGcMMMDM4fsXjjvsGLlUP+NmYD+jB8kHPmus4RNob7UOgjOZrr4DrEJ9JU5apOgIKgqSo4VuB/T/8VRKwWkR8hrc+gXh3QJvtvHzjJry4ic+eJl5U2ibAm6eV69GkF7li88bZVLjbMZXL1FR0WmM/38hEdAe6AWeEU9ulIL8BEIxfEwlfXuZd3ieqtiXhPR2mqDv4SiUtmRPILoSpWY4RnO13oNIzpcOVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bECNJvu/9KyTMB3N0hVwlBJV48d9S2lXGuROiqRtFDQ=;
 b=jeNDRjyX4RRSRIskWVQPoc4puUz8PcL4hctlbW8s/igUR4yq6gKzKM5fDokEED0tqMifYZu2iEcR2Y9+zk6Hcm5ImCy9eDmBA6Gs496bUICzXahqupEVTW3m/9mgaXUTNgEsC6/mD7qwk+3ZEidhV3QT7yNfQiGfJ9ZCeL3JsZQ=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4413.namprd12.prod.outlook.com (2603:10b6:806:9e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.25; Fri, 4 Dec
 2020 21:38:59 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec%3]) with mapi id 15.20.3611.025; Fri, 4 Dec 2020
 21:38:59 +0000
Date:   Fri, 4 Dec 2020 21:38:52 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, Thomas.Lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, rientjes@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: Re: [PATCH v8 12/18] KVM: SVM: Add support for static allocation of
 unified Page Encryption Bitmap.
Message-ID: <20201204213852.GA1424@ashkalra_ubuntu_server>
References: <cover.1588711355.git.ashish.kalra@amd.com>
 <17c14245a404ff679253313ffe899c5f4e966717.1588711355.git.ashish.kalra@amd.com>
 <617d3cba-cbe0-0f18-bdf2-e73a70e472d6@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <617d3cba-cbe0-0f18-bdf2-e73a70e472d6@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN2PR01CA0006.prod.exchangelabs.com (2603:10b6:804:2::16)
 To SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by SN2PR01CA0006.prod.exchangelabs.com (2603:10b6:804:2::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Fri, 4 Dec 2020 21:38:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d4392d3d-8d13-4cf8-afc0-08d8989d01cc
X-MS-TrafficTypeDiagnostic: SA0PR12MB4413:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4413854223B43A9FC1233EEF8EF10@SA0PR12MB4413.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4ldFQOlYDU6ewaCv4b9AOKhgBnzaeBQMlWnFPT3H9hLnQ8ndB26n4FzRo2HWEVm+alp+08xnA5BiuOyAOwsB0zCh+Bqk1u/yGDRLvD1h4+G62C5C4ZbuDhY8aCPbi3qLmBw6CAN1IfuPzSUY6EUc2n7Vhjr7h2Sm+HLi4HS9HtJ41fbkOQ78pZe8iu6p/orccc6XI0v5V/QtNjwkhOrynPvZflQKVIFenWVsI/hW0xD4yiTqD8FObJHupnxnLOzqc5465W9dh+pKds6e6Q7TIinfRFt3FdF6AhhkA5UMJhpHq7DRrH06C7YhxwDsKJYCbhzUFJJOThZGyNL8jEOLYQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(39860400002)(396003)(366004)(6916009)(4326008)(66476007)(956004)(478600001)(2906002)(66556008)(66946007)(16526019)(86362001)(33656002)(55016002)(1076003)(8676002)(186003)(5660300002)(53546011)(8936002)(6496006)(83380400001)(52116002)(6666004)(33716001)(26005)(316002)(9686003)(44832011)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?qOWmHxNrk01GIITifCA8Mxn1LPFqiaTezWuPQweoxM+Lpl0Zjo6ezEdtgfBr?=
 =?us-ascii?Q?wXfro4EzWiXZRgvhkaLzSUCNwvqelGVmH8kjQzn7Ia7sSO9VzidzZegKbKWw?=
 =?us-ascii?Q?tN+uZmOhcCh2SVGayvsp1KIY66r0BrsKtM779YNfRlQlauu7SoM3KZPbB0pO?=
 =?us-ascii?Q?KbKppVnqAcOENSHOnUjGIlovZYjoAaMFNvopaP5FxpY+4E9Znnb7xfzNWDlo?=
 =?us-ascii?Q?CA/577zwwhpMmQrL1gK+eFkxNea53RmDQ0R9oA3UOKrPY9B1XOR1aQbmQ50A?=
 =?us-ascii?Q?dO0EJd74kcmNiQe43QXiOggS3yi/yLMHLEvIeUY/n53jBsFIwKuWAVZ/an7n?=
 =?us-ascii?Q?u1EQm1KxZccm9z/8D4yHLpTU7UFm8KdXEhd4cmXRkpQYz4N0PzDTkA/8p4VV?=
 =?us-ascii?Q?iFgsTxMjuF2h9vXJ3DIGe4P0ayog2TYH6bRm6FM4ktKEWlugHxKQ6/DzWXtI?=
 =?us-ascii?Q?J3qmrOg6TQXnOuGTQHKWC2CzfQyX0k00zisuYrA4XfJfPbKc9r8vREBtBwU3?=
 =?us-ascii?Q?B4Nht0F+hgrCZelFK60xF7Yo08evzf9nLiQbNgZ5UKYlOYTMS9BLyduvo4Bl?=
 =?us-ascii?Q?8z5uGECtpFr7zTj7BfgsLgGdJ1/QjsRPhxggFp25pp/MqdIGvg4jQUMNUOQe?=
 =?us-ascii?Q?LwDrQbbZsPvcHYnMo28cIKxS0YAYQLfMDmWTcHmYu9fFpZ8xCMQOwzgjfE7t?=
 =?us-ascii?Q?5f26Tj/qAi+6vPjqVNvymEA7IEvY3dUgx0n+5aMqPEp0I00139Vobp60XvAH?=
 =?us-ascii?Q?88MLeqTV5hs6r8c36IWFQWzoSPFyMRCiUYHb9R6wFstRMEMhpicedCv7nect?=
 =?us-ascii?Q?du4zEE+vzDx6Lm4smt4Jrj2P0Quo3nTb9j/QiFZCpRiCTXWk9eGygLGk4/9z?=
 =?us-ascii?Q?HzJKhnD5lQ+U4nQE9mJVuVVGpSb3xHuMo/PUsbmiv1uJuNvk51/M8QYtMFqp?=
 =?us-ascii?Q?EU/pUZWs2ffc1JN+Q2OyV14teauEd1l6Qt4lyWox7UBINvqsH2QTZ8fOKSjk?=
 =?us-ascii?Q?Q6nh?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4392d3d-8d13-4cf8-afc0-08d8989d01cc
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2020 21:38:58.8549
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bsTyi2MUb1I3msIEqhKP8AMwIYS1bAvmjJw5elM0tjtom3lkBAFwtP1YbEofEUn+mXO4an2RNKiTUVozT1muUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4413
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Paolo,

On Fri, Dec 04, 2020 at 12:08:20PM +0100, Paolo Bonzini wrote:
> On 05/05/20 23:18, Ashish Kalra wrote:
> > Add support for static allocation of the unified Page encryption bitmap
> > by extending kvm_arch_commit_memory_region() callack to add svm specific
> > x86_ops which can read the userspace provided memory region/memslots and
> > calculate the amount of guest RAM managed by the KVM and grow the bitmap
> > based on that information, i.e. the highest guest PA that is mapped by a
> > memslot.
> 
> Hi Ashish,
> 
> the commit message should explain why this is needed or useful.
> 

Earlier we used to dynamic resizing of the page encryption bitmap based
on the guest hypercall, but potentially a malicious guest can make a hypercall
which can trigger a really large memory allocation on the host side and may
eventually cause denial of service.

Hence now we don't do dynamic resizing of the page encryption bitmap as
per the hypercall and allocate it statically based on guest memory 
allocation by walking through memslots and computing it's size.

I will add the above comment to the fresh series of the patch-set i am
going to post. 

Thanks,
Ashish
