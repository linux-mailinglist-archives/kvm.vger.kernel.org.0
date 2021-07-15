Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BACA3C9AE9
	for <lists+kvm@lfdr.de>; Thu, 15 Jul 2021 10:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233061AbhGOJA2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jul 2021 05:00:28 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:55488 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229927AbhGOJA2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 15 Jul 2021 05:00:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1626339454;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s1pDTT76JlSd+T7hQOiQmZbciuotsFPZU63IWqljbjg=;
        b=dqIo7KAcN0TNqn1pFCRlsgOv5THycN9hHUXBtaEzS2isLDoiEisrRXKoK5vZ4S9X+57A+Y
        qXHAiYRJL821Yku8T/98499KRKFMSHxgaJPb58E+Y6KpcDeDdviC2zZj8GbrwdxUrzhhUB
        ROCFylppCkgGH8IA8QBbStXs3B6ql6s=
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur04lp2052.outbound.protection.outlook.com [104.47.13.52]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-39-sCp84dYJPXqg5w-TEGrYNg-1; Thu, 15 Jul 2021 10:57:33 +0200
X-MC-Unique: sCp84dYJPXqg5w-TEGrYNg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QJ6VhqPD8cezQgK9R5tMM6CM+xhdjXg8mehf/3eg8+1Zjryfua9ic1Pp+oTMSyDSRFvmn3sirRIDIwF84GeMtMm0JswGqsKVCk0ON4BZFEoifCKYKzUVBqqLnDHpVzh9NCtaFrAsjPAYoxFflwcRZo+aLiw7kTy9CUqhvrx2rjXwwjRsiMsYWniqcmJtW7u0cpX7ktO9ddyRCJORgxMXI89OvkRCSvRWSCb7k3LZxmelKBY8FJcS8UhTfJQSEz37xdje7eHlTuxf2I0FJHCi1xOuYwrMi91MEHg6XCmWU04rRbtdOnPUyfUmbaYGw9J8XGlWfG+YBVg9MupvrnCh6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7OoXijwnXMucQbk2vE58ulosbi1bw1kMTMJjzhAkIWw=;
 b=cpz+HsS6mDyinPo52TuS9AHAAeu3fvi7O9UU2pfQBpPpeeG9EXAXwRnN6OnlxGb6qBbcGWzrVxg58ZThstqMu4plJF6riYlMn78RwTNL3w8F58e8J4x1xhFHeDAD/cebv7X1zdfn2Pq2G9FGHQ+sdmhR4btP1Rp83QrzlWuHsZSCjJbJ2XpRbf1SeaVE//KX6300z02npvaxShdWN4f5EOmZvJ5XwipqpmJ3lqF3GizSWASaGp4KRlNdB3YlgfixsVk9tEsSjmkIZdAujk/Gqa9r2+4nn8ak+F0Iplhr82g8Qy79QX4BRo701TNhits+lGbOnlpU6K6Bal5PKIBxKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: lists.infradead.org; dkim=none (message not signed)
 header.d=none;lists.infradead.org; dmarc=none action=none
 header.from=suse.com;
Received: from AM7PR04MB6821.eurprd04.prod.outlook.com (2603:10a6:20b:105::22)
 by AM6PR04MB6645.eurprd04.prod.outlook.com (2603:10a6:20b:fe::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.23; Thu, 15 Jul
 2021 08:57:32 +0000
Received: from AM7PR04MB6821.eurprd04.prod.outlook.com
 ([fe80::816b:1f6a:c279:1b65]) by AM7PR04MB6821.eurprd04.prod.outlook.com
 ([fe80::816b:1f6a:c279:1b65%3]) with mapi id 15.20.4308.027; Thu, 15 Jul 2021
 08:57:32 +0000
Subject: Re: Any way to disable KVM VHE extension?
From:   Qu Wenruo <wqu@suse.com>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
References: <37f873cf-1b39-ea7f-a5e7-6feb0200dd4c@suse.com>
Message-ID: <be2551ac-2287-e2f0-7247-4bce58a82eae@suse.com>
Date:   Thu, 15 Jul 2021 16:57:23 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <37f873cf-1b39-ea7f-a5e7-6feb0200dd4c@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SJ0PR05CA0056.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::31) To AM7PR04MB6821.eurprd04.prod.outlook.com
 (2603:10a6:20b:105::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [0.0.0.0] (149.28.201.231) by SJ0PR05CA0056.namprd05.prod.outlook.com (2603:10b6:a03:33f::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.12 via Frontend Transport; Thu, 15 Jul 2021 08:57:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e81eddc4-7a8d-4b3a-e9a5-08d9476e94da
X-MS-TrafficTypeDiagnostic: AM6PR04MB6645:
X-Microsoft-Antispam-PRVS: <AM6PR04MB6645612AB2CE4FBEE6EAB050D6129@AM6PR04MB6645.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wZIGHShSE1rkeV3b/PaEUYBytaoP1wtyX8EtqOgVFnlQpCbFhcZ69H7odrtJsyUCLht7t/WkhBaz5QVPwGJuZNOnjUGZRzgkkDcZ/HveiAnAcqDC+KQYSjigD/1Hq+8hsn3I93Ys0Kxxy3AEIfCPsPkciUdKp5yaOAj2BakmF+3DZNh4FBAGv1SEMqVEosxkHZ3a5OZOBHofTENtREhDh6XaVf8tVkhcXucbbwbKVhylgd/ejFLVWh485r3YdLl8of8XBVdA+PyryIkYpFmlgNteTyBq3ZQAT7qjJ3d5VIc3OqqHusfomxMx/mSG8XT4pMEWUbkpzEHVWsGcVk8n2FsUMLZOParUjtDwQ9qXHfYZlJZTHuslEaZQIzUWw9b+GDNgPL40L/kysE6KIHC3gkvA5/lPjZzqREXixnLsqxslCg7/JR0xG0y7N3JeEYJBLLWFgxUull15lu09iwRKcAdfoEnNZreFxsAf1TIbsPYk/ookCENrJN45mc86YJ03mmhkKZvguKZ+6XqjnDQIZm/ysjR5SsM7HWX5tAF6v37Tj0pi0mC+el5xl8J88lqc5Ey9INnmvMMRD7t4cKGWTfdSE078+aLvma8lMqcDN66NUjwbmgoylV+xT/w5Cht996G4/AG3PV0DN1Z+nIQSB93pDDSCtxEp+sHXnJAuh1XfienKn42mE/O4aibvh4fTMmxoUBlEMUJb/3NLS1cebBn//iGHyhrEXlNu2cu0ZqgTSZRCwDOUNe23IbQqYntBoU8ryWKZ6rdsDFaOBxDkjuaxL9ee5Pu3lVaLystqOu0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR04MB6821.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(136003)(396003)(39850400004)(346002)(316002)(31686004)(2616005)(66476007)(31696002)(8676002)(66556008)(66946007)(86362001)(38100700002)(16576012)(8936002)(956004)(6706004)(2906002)(36756003)(6666004)(5660300002)(6486002)(83380400001)(478600001)(186003)(6916009)(26005)(43043002)(78286007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dVXsg6HsJlUTx/g/JoZcI+8fjrrsFdEmEiByyzNDGWRq6XUdZ2qWAzYGbF1t?=
 =?us-ascii?Q?a5nIUa4zUg7FHTG4ArxLOJQ47J0ildUorV/0fE6OLW5TqrUXhBxPk13IAwvD?=
 =?us-ascii?Q?pO2M1Jo2zxTyIfWB5CR9ybqU/YDVKI0V3ABwGuyXT1Q0AT8FYCk6PsODAcjg?=
 =?us-ascii?Q?DuMZsmyw1bBmbwrvuXG90HDaI41woJqkcb5rbd2dO41ytl7ME9cEKKaMoZIm?=
 =?us-ascii?Q?FaiNilMNpujlaNi8wtSoNeVMNbbvHKh9UURyV21iTqEECedMQ5RdzNwdUAX2?=
 =?us-ascii?Q?zF26XtbiqbqS7nN7mOkxbX80j6WyRbgLG1xAfE99jEi/sE9jDA024X9IPVB7?=
 =?us-ascii?Q?AUhYiJc4aJFirzAFaal3N5/TUeqoO56P3IIK9eBrlmIplTNf2EcW6wSaOQ8p?=
 =?us-ascii?Q?LjuUaEHZecvv71kyc99D2/w/4pQGmUegTEezE4ClXjudujUxO4cT+m5/1zZq?=
 =?us-ascii?Q?ucrT4agSHjo5lCdRkfkcQN73eJMokXOAayNHUbJJPHuEqTVAoG9ifkjV2gDB?=
 =?us-ascii?Q?m/UHsWAJr4PLdZdlQpXC5zYaTZu2HNXN8zagTCywCcczQGg+s+WnbRsONMnE?=
 =?us-ascii?Q?Nt+XVFttpPviU32KaM0Gdjnsr8KXi0xmb6mGR5xGOYzuWZN9yetNI8gm+RBn?=
 =?us-ascii?Q?hmelHIIwX8zCCw1KcbkjpxzPK2vo5zVhO/ZPqj+feOulIuesW3QvihMO2nU9?=
 =?us-ascii?Q?UtZfdeUkO/y/gON46iRkWRrYP22ZgqDlCkPs07YJCeLbTW8BfGoyvEl021/v?=
 =?us-ascii?Q?uisrYi8LFKjNMmyf3PDQsQeN4mp3RmGCy6RXnZ4oe5FkPdd6Gia325oaYxJI?=
 =?us-ascii?Q?U+WIXneF7oz0jnAgOuYyhj52YHkcl8TuqaiVZlE3NofiaoVyPCQvHVAGd5y0?=
 =?us-ascii?Q?B17teQR7nISPKHJvgid6/GUfvAKpajUT7ZLyGkja82ZzrEv8lKmPxWBp2LFv?=
 =?us-ascii?Q?87jKJIlzoy9n8xcdgl075WS+foGnJ1ffXJ8PYITATeHAD0LW5IPUoo3YkEAO?=
 =?us-ascii?Q?UeN1nGYFar+Qeb98Mr6EEpNQLHC/NqGUTN/UygtgLK32Q6h6BgDS5G9omfzU?=
 =?us-ascii?Q?o/ecX66koR+sDkkIzQY0Fn64rMOm6LKdv8PGqiEQ3wRQwnuQdN4f+kGBfyIU?=
 =?us-ascii?Q?uyWxwGyuEOlv/376feRFi0/dUwXO7W80mf45Uyo02nk5YPi7wVnfXciEeYwq?=
 =?us-ascii?Q?1UaG4Be6ZMiWhXrkr6bkBt2Ys9fG/8GUTcsxMtuQNJ3OJsntt5YTWZZLQKPE?=
 =?us-ascii?Q?+IkG+2MC6UCzgycug84O8KPjoF8d4ZsegRisAOSe+xjrAX4QRgAHu/8ueH2N?=
 =?us-ascii?Q?zppW2vTmAybu55EiDHoyMye8?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e81eddc4-7a8d-4b3a-e9a5-08d9476e94da
X-MS-Exchange-CrossTenant-AuthSource: AM7PR04MB6821.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2021 08:57:32.1543
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lfc5p0NbFzBmVUI1PqhEB1dVWAaI3eoX3kejdfokFGhwhtrBRJyz2Beoi8ngtLLS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB6645
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2021/7/15 =E4=B8=8B=E5=8D=884:55, Qu Wenruo wrote:
> Hi,
>=20
> Recently I'm playing around the Nvidia Xavier AGX board, which has VHE=20
> extension support.
>=20
> In theory, considering the CPU and memory, it should be pretty powerful=20
> compared to boards like RPI CM4.
>=20
> But to my surprise, KVM runs pretty poor on Xavier.
>=20
> Just booting the edk2 firmware could take over 10s, and 20s to fully=20
> boot the kernel.
> Even my VM on RPI CM4 has way faster boot time, even just running on=20
> PCIE2.0 x1 lane NVME, and just 4 2.1Ghz A72 core.
>=20
> This is definitely out of my expectation, I double checked to be sure=20
> that it's running in KVM mode.
>=20
> But further digging shows that, since Xavier AGX CPU supports VHE, kvm=20
> is running in VHE mode other than HYP mode on CM4.
>=20
> Is there anyway to manually disable VHE mode to test the more common HYP=
=20
> mode on Xavier?
>=20
> BTW, this is the dmesg related to KVM on Xavier, running v5.13 upstream=20
> kernel, with 64K page size:
> [=C2=A0=C2=A0=C2=A0 0.852357] kvm [1]: IPA Size Limit: 40 bits
> [=C2=A0=C2=A0=C2=A0 0.857378] kvm [1]: vgic interrupt IRQ9
> [=C2=A0=C2=A0=C2=A0 0.862122] kvm: pmu event creation failed -2
> [=C2=A0=C2=A0=C2=A0 0.866734] kvm [1]: VHE mode initialized successfully

Wait, the kernel I'm currently running on Xavier is still using 4K page=20
size, just like CM4.

Thus it should not be a problem in page size.

Thanks,
Qu
>=20
> While on CM4, the host runs v5.12.10 upstream kernel (with downstream=20
> dtb), with 4K page size:
> [=C2=A0=C2=A0=C2=A0 1.276818] kvm [1]: IPA Size Limit: 44 bits
> [=C2=A0=C2=A0=C2=A0 1.278425] kvm [1]: vgic interrupt IRQ9
> [=C2=A0=C2=A0=C2=A0 1.278620] kvm [1]: Hyp mode initialized successfully
>=20
> Could it be the PAGE size causing problem?
>=20
> Thanks,
> Qu

