Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF21F3806D6
	for <lists+kvm@lfdr.de>; Fri, 14 May 2021 12:05:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233926AbhENKGs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 May 2021 06:06:48 -0400
Received: from mail-bn7nam10on2050.outbound.protection.outlook.com ([40.107.92.50]:27937
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233937AbhENKGi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 May 2021 06:06:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XguPWocCLC1XMkelAHLmuahQnZZIyVY7PIgsitFFhNAfiSnlb3YaxI83tcCwpPF/D573zRTRRBmaL5XI051gclOBmrPP7srHelfc8PCjYfk5tKZoIqw/knSQXLTQ4zod0GPi3cWtFX8jv72+Pe5HK/wucTSU2dvTmQA0oFQ+5qElQwwqWpv+pna1/6z2FfLQT0j0S5orEfM+2/iKxWKvxwc1/NcYqjuPNAE+uTG6YV8fz93BFMIFm56yzhJKpNDxGOYwISv3HE/QSbt6OEJ9HLhX+mQjHkv5r+8FIF6SSOZoR5yYOs5dwEIAudIqVJ141MKRlj3Cpl9gkxQv4j4xCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=prpTsYwbBGQCgHYfNn1MXuAQzolCxz3IAMkBkSYWnPw=;
 b=agZBvMlNvDjxS2XKIVsMmsgkH1XP7LDe3JkH2cZOP5pv+sl2Uylmb03BU5WPHLExI9b9M8XWRO7svnhYkqTvVdw0CB38Ss1cFoSdH1fzybUEhNx5e/Ls9SBjSPo5uBu2bGeD8vgChENGQ40hc7o9r6p/faobiVU8n+iWSLYP7sRptJZrXRJskHK/vKs5whpYlhCkzGhCDZE3TISOhzqWwqH3jjl11R3tIVkfUT9EPSN62++cI4Kk+sGwL++hEBRrBj+Kqj656Io+16WnB6215gB01R+gomNZ5eKOzj3z8zYnP+JZzhsh97OHQjkVaWiHA4vpZGL360W4xQqaTqZujg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=prpTsYwbBGQCgHYfNn1MXuAQzolCxz3IAMkBkSYWnPw=;
 b=P2yVhiflCuCLeZgp2N/gNd9R1qDs34Ii/NRB4bqELl75cs7Y0L4qdrZypMRO2nvnFdGfsGU42upCtHzTw9Wr+0eRBRoVZmjQDqWQylUKtqwr/+Am756PI/RHkEcn/5PZTL0BjnuRDd824QbFR8IseWDyQnnGVedZS5CiOsXJgKs=
Authentication-Results: alien8.de; dkim=none (message not signed)
 header.d=none;alien8.de; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4415.namprd12.prod.outlook.com (2603:10b6:806:70::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.28; Fri, 14 May
 2021 10:05:25 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e%6]) with mapi id 15.20.4129.026; Fri, 14 May 2021
 10:05:24 +0000
Date:   Fri, 14 May 2021 10:05:19 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, seanjc@google.com,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, thomas.lendacky@amd.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, venu.busireddy@oracle.com,
        brijesh.singh@amd.com
Subject: Re: [PATCH v2 2/4] mm: x86: Invoke hypercall when page encryption
 status is changed
Message-ID: <20210514100519.GA21705@ashkalra_ubuntu_server>
References: <cover.1619193043.git.ashish.kalra@amd.com>
 <ff68a73e0cdaf89e56add5c8b6e110df881fede1.1619193043.git.ashish.kalra@amd.com>
 <YJvU+RAvetAPT2XY@zn.tnic>
 <20210513043441.GA28019@ashkalra_ubuntu_server>
 <YJ4n2Ypmq/7U1znM@zn.tnic>
 <7ac12a36-5886-cb07-cc77-a96daa76b854@redhat.com>
 <20210514090523.GA21627@ashkalra_ubuntu_server>
 <YJ5EKPLA9WluUdFG@zn.tnic>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJ5EKPLA9WluUdFG@zn.tnic>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA9PR13CA0001.namprd13.prod.outlook.com
 (2603:10b6:806:21::6) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by SA9PR13CA0001.namprd13.prod.outlook.com (2603:10b6:806:21::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.11 via Frontend Transport; Fri, 14 May 2021 10:05:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8908731e-47bf-4340-ee6c-08d916bfcac4
X-MS-TrafficTypeDiagnostic: SA0PR12MB4415:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4415611653693940CAB565508E509@SA0PR12MB4415.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F1M1T4PwrcC/WjqrlX/YX83SZn0d4Il3B4cM544NfVADfIq46wS3/YwTD8RyCAB0SA9YOEFO9qDzXmcdnM0IyaxUST9KvitO3Qut44lFe7j1SM/oMldO1bY1sCjb7OW/16JB6a3MGuB3FExc/jio8qwEZm8atlzYCaTqowohq7L7ezlED2Bckx4DV4I/kLED1WAs6SxHbpUwXD+QWee8ysVbz8qjpAuWuAuMce3LU2s9v5O4zyOD9AsuKVMSQrSkuQ/X7rGuDTB0SvTEobIBAXaSblgGlBbcekSY+CRXBbrUL0OgLGpfYGVYGlaOFt9eMuAGCSHVUGlsrRxAO2bwx7tO2ZsLaOnnOyTA5GRk4AbDRvzA1Ergho3yY29wHl9VlpRMxfDxQVnLm+FDJjMKtmILUl0mmM9rxbaGh8oxLzXvbPecJlM8Ud3R9nFITQS401LbCENynPN16z0ku38WBqnG6fEGP7o3MiUp5lbOGR8fdO6PjwdvsZ4/mwostshMk3ZTCa5Y77t2Jq1jjmPnAt34sqvjbrPqI0uK9aS7WbG4aGyEVcKNVA1Z/7ByPTtZnuig3vfMtZfcHf2r6tnE+OHCv6Loeb7nCl0oVtldTnkiyc//8OVGiBDdMjLn9iBd5voWQMqp+NU3nA93MGx/ZzX64N7pp+cJIG5aNyqLlKQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(346002)(366004)(396003)(136003)(376002)(5660300002)(186003)(6496006)(16526019)(2906002)(1076003)(55016002)(4326008)(66476007)(8676002)(86362001)(44832011)(83380400001)(6916009)(956004)(33716001)(38350700002)(38100700002)(478600001)(33656002)(26005)(8936002)(9686003)(52116002)(316002)(66946007)(66556008)(6666004)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?lsHdS4CSzYFDAkdJ6mQpBh39s6Sj3mZnUFU4y7gOxPuprOWOEvT3bDfu2Kfz?=
 =?us-ascii?Q?KstZp1iNHmBMWz9Zy1op0M5soQwuV1Brl0n5qvyQaoS9X/ubHbpiYLN6uOjC?=
 =?us-ascii?Q?8hFj2yMmjWT9hlJnywysodNauzCXNqtVAmXcM0kStEZ0Dqr/cyCtyNqcGZhY?=
 =?us-ascii?Q?ZMpcmWx+0Wzg+PltxL245xw9wh5OjVPlIdfUx9jYVwgaaKq51iamwVGkhZHQ?=
 =?us-ascii?Q?OJWNHVqKz38m19RuHTK5xPr+EKOD3h28qPJraVlILP1ifnts/22ceuBdelP2?=
 =?us-ascii?Q?JPbyaC1djEv1mxx/4KDJjwi+HtGO6Fg1KdLRWIMGOtgSrRaRniKoOMmkSm7h?=
 =?us-ascii?Q?9ovOoZlZkIhroe38nyDyWYCZKGtsoMfaDPrAoZHp4cOUZLcROe6x2jngpjKm?=
 =?us-ascii?Q?uHSTReUAEg4geyNVWghjH1CFpB6OCjt6NhMveaRjUl5IvOonkQEyJx1o02kX?=
 =?us-ascii?Q?6jkSILSyX/LWIkiLW4DjqZ/Zm4ljxbItSRZ513XvFu5sveaatTmkrUtl/o4R?=
 =?us-ascii?Q?Ely9DlGQMs7XpxBJ1pcXAcjBRzIUUtT6ctKuP8v31emPz7ZgbeKaGRGDIK5N?=
 =?us-ascii?Q?1euWhYT6NAao3Oq2KofXWptcasQ/9kP/0n8/E9AjHlNtfFvWwasnTcNTRkA2?=
 =?us-ascii?Q?qoUT1iqx6jHfsvl3aGeDbJmXfKAzGKoCUyg0rywNNPHQL7ulF6wah8EgXNUM?=
 =?us-ascii?Q?qvgmq2MJyROhEyTb1cNSh5Xyqc61TrHz7otWTbcZpQHKndn2oYXuaiYdasAw?=
 =?us-ascii?Q?MWcqlIc62yYx9kNnl7hIsMAvNgau2z7uI8gv/KF5+8EbHJviRd4EN7J9KBt1?=
 =?us-ascii?Q?OeGuN10KQVIVruKXel6jl/wEIeIxsg7uOCZr8LxEiJM+JZs096lIDLX3A/up?=
 =?us-ascii?Q?1pg7n6u2aENs2x4GWN5ASKawb9c1n/fjvziqlUGdClWL3M2pQ8b902YvuzPG?=
 =?us-ascii?Q?Q3+9zCzgRJzYsqGxpAiwaLhpqkKh5pA9qvA6H3CuML/58CR5XwroDrz4uXKQ?=
 =?us-ascii?Q?hwOAAM0tYighT+uctysotB0j/L/7ofw3t52vg10i2xn5ukNhrefUO0lL+mJi?=
 =?us-ascii?Q?CD3IgQYyL8v4b9agIzJoFfupwOwoJsQn2Q68HjNnN5KAz+XRxwpcknlEWUdu?=
 =?us-ascii?Q?gTg1qS0TO7+9cALdGghIPXR/QCwyQE49hdX3y6MUpHkQ/2V8uAbEKVkVF4Vb?=
 =?us-ascii?Q?fCOvZrTWZ/sLCNLyo/t3PWKS+KPHrhW5DW9mrsXLqi7mg9+Si33ecM3GGYzi?=
 =?us-ascii?Q?6Dr8w11o6VLdnlWf1TZ38/ihr9Tc0ERCRQ4DR+ErUwjpaZ+XkkWV5/fAeDVl?=
 =?us-ascii?Q?nVFoK2SNrTZ7nRz2qpy2fCgv?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8908731e-47bf-4340-ee6c-08d916bfcac4
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2021 10:05:24.7773
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4bl2iCi2ufHI/7ammzunBNWqcNhpJ3l7Q7vT6P6K1+Y2Qk4PQhuoGbcFFay8RB6Io28u0drCSjuLf2OGy0DH+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4415
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 14, 2021 at 11:34:32AM +0200, Borislav Petkov wrote:
> On Fri, May 14, 2021 at 09:05:23AM +0000, Ashish Kalra wrote:
> > Ideally we should fail/stop migration even if a single guest page
> > encryption status cannot be notified and that should be the way to
> > proceed in this case, the guest kernel should notify the source
> > userspace VMM to block/stop migration in this case.
> 
> Yap, and what I'm trying to point out here is that if the low level
> machinery fails for whatever reason and it cannot recover, we should
> propagate that error up the chain so that the user is aware as to why it
> failed.
> 

I totally agree.

> WARN is a good first start but in some configurations those splats don't
> even get shown as people don't look at dmesg, etc.
> 
> And I think it is very important to propagate those errors properly
> because there's a *lot* of moving parts involved in a guest migration
> and you have encrypted memory which makes debugging this probably even
> harder, etc, etc.
> 
> I hope this makes more sense.
> 
> > From a practical side, i do see Qemu's migrate_add_blocker() interface
> > but that looks to be a static interface and also i don't think it will
> > force stop an ongoing migration, is there an existing mechanism
> > to inform userspace VMM from kernel about blocking/stopping migration ?
> 
> Hmm, so __set_memory_enc_dec() which calls
> notify_addr_enc_status_changed() is called by the guest, right, when it
> starts migrating.
> 

No, actually notify_addr_enc_status_changed() is called whenever a range
of memory is marked as encrypted or decrypted, so it has nothing to do
with migration as such. 

This is basically modifying the encryption attributes on the page tables
and correspondingly also making the hypercall to inform the hypervisor about
page status encryption changes. The hypervisor will use this information
during an ongoing or future migration, so this information is maintained
even though migration might never be initiated here.

> Can an error value from it be propagated up the callchain so it can be
> turned into an error messsage for the guest owner to see?
> 

The error value cannot be propogated up the callchain directly
here, but one possibility is to leverage the hypercall and use Sean's
proposed hypercall interface to notify the host/hypervisor to block/stop
any future/ongoing migration.

Or as from Paolo's response, writing 0 to MIGRATION_CONTROL MSR seems
more ideal.

Thanks,
Ashish
