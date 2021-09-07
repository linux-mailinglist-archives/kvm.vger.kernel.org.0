Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 453BF402D14
	for <lists+kvm@lfdr.de>; Tue,  7 Sep 2021 18:47:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344950AbhIGQsd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Sep 2021 12:48:33 -0400
Received: from mail-bn1nam07on2069.outbound.protection.outlook.com ([40.107.212.69]:23934
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1344752AbhIGQsc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Sep 2021 12:48:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RDNzSjhhVqyUdOGJcjIru7i6zJChVM/OSjyDD0G+wneGByfkPKMYieLuIsTx5kr7kSjPgTLyuAFG3yeT1SoTIHvLaS1ZaxyG66Fr6eTL2aIYGYwN5YePdKwnHF3/5Ag+t+HSpxSeiFI4RV56jf0gsnJ8o7OS0uQMA1zGC4OMM8vpFw/vWBBcfAI8qafQMfw4T9BKq68A665wFuUbqzTnyl28M55ltSi3wS7EkO3bCxKAiBCNw5Qkhqs74Jk6UJ3vdQG+OIhu3W1u2XspYIRhO3lFuS/4fXbb/6lGuLqLzeuzMnABX0lDruUUSUPN7aJNgIRicj9z1dXUAai8KDxNWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=2f+bMr5Nlqn8TzMriAfeeWyFeDUX8WynpsRDcPE31KY=;
 b=FW0HleSs70+l7MKZznAjtFsr/8tNwqmKKALX2rVefmB3mpF9qaX8bEl3kc4V8Pk526pYOPpd76Dgw0dxf0x8NywSKUBKQKFB4gpFQLYCnxaLBaqANl26c0ZitCClQROCzSjTYIYDhRLz7Fs5IO6QSZHRhKxc53bzT6PQvytEyIfliRNBJy53fvqYrMTiHOQ88FU75pY3nZCXSYu/m/BLQ71CHMVGWP80dISqB9dGqZZi9XYKVN9S7QABXFpR6MmrHIYGWTBNH3KwRGaWizrRlnnCpczuP5denzSZO8QqpnPswrHcfuomZI/OjvkzHDCE4yuHjkL4V5imtr4+t2ELwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2f+bMr5Nlqn8TzMriAfeeWyFeDUX8WynpsRDcPE31KY=;
 b=lb6UBbJApkCyladRgcr2vqn7O9uveRLuNxUPgOacIZxR9m8eADwqLwphBIYVw5D3j4qFhgz9FWyld6fN7tOgjyHCRT43G61IxAO7Ekg5NPYrQVZNIU2zREZDBTuQea/HqnerNFNw2836UnnAmc4mETB2+RdaE5UI93KILdg90R8=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=amd.com;
Received: from CH2PR12MB4133.namprd12.prod.outlook.com (2603:10b6:610:7a::13)
 by CH2PR12MB3704.namprd12.prod.outlook.com (2603:10b6:610:21::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.22; Tue, 7 Sep
 2021 16:47:24 +0000
Received: from CH2PR12MB4133.namprd12.prod.outlook.com
 ([fe80::f5af:373a:5a75:c353]) by CH2PR12MB4133.namprd12.prod.outlook.com
 ([fe80::f5af:373a:5a75:c353%6]) with mapi id 15.20.4478.025; Tue, 7 Sep 2021
 16:47:24 +0000
Date:   Tue, 7 Sep 2021 09:27:09 -0500
From:   Michael Roth <michael.roth@amd.com>
To:     Dov Murik <dovmurik@linux.ibm.com>
Cc:     qemu-devel@nongnu.org, Connor Kuehl <ckuehl@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Daniel P =?utf-8?B?LiBCZXJyYW5nw6k=?= <berrange@redhat.com>,
        kvm@vger.kernel.org, Eduardo Habkost <ehabkost@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Markus Armbruster <armbru@redhat.com>,
        Eric Blake <eblake@redhat.com>
Subject: Re: [RFC PATCH v2 02/12] linux-header: add the SNP specific command
Message-ID: <20210907142709.6dlo7ate37ublhch@amd.com>
References: <20210826222627.3556-1-michael.roth@amd.com>
 <20210826222627.3556-3-michael.roth@amd.com>
 <b398a4b5-cd8a-c6e8-d30a-ddac3de97393@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b398a4b5-cd8a-c6e8-d30a-ddac3de97393@linux.ibm.com>
X-ClientProxiedBy: SN2PR01CA0073.prod.exchangelabs.com (2603:10b6:800::41) To
 CH2PR12MB4133.namprd12.prod.outlook.com (2603:10b6:610:7a::13)
MIME-Version: 1.0
Received: from localhost (76.251.165.188) by SN2PR01CA0073.prod.exchangelabs.com (2603:10b6:800::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.20 via Frontend Transport; Tue, 7 Sep 2021 16:47:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 587e5f88-3a6b-44fa-9169-08d9721f2ae4
X-MS-TrafficTypeDiagnostic: CH2PR12MB3704:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CH2PR12MB3704A126E8ABEEA1D725AEB395D39@CH2PR12MB3704.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XbRhpKX0UguWrltcqUe/hMcqiNGzr6nQasBHSgXPfqjXxPsFg0aQPPHgQ+2FrY4nkNkFy6tiVnA0gJFJzUksaLubwKNw8GG8uO2SlvQBgaaeqUHzVcAybq4cIA2bU/jAgHlJaJXwGFW/NHpvHVgmLHS89UnRlhSk8mJFY4/HEFK+0gaSwLsMx5RuV3abgjrVC5IQ80tQD47RugiVHJpM1iKMET9rM2Z/7JPxdc5BzX6LOcJJLQUu7wDe0d/6ywJwCBI4B2kCzxjqvN/3ANZV1V5eaH/J50+nXQz0r93EThKgoGZjZNE5KzjiZN2imnQvbj90NP8pG1j/Rc/Xj2bNB1ELd8JixjXoMRYOwTWgT0//YWNBB6vq24s5SJxgu/Oofc7A9/dwB7VblrylrKHgh+EHm76iJ0GV7bNwhniDCkdBZEa7d+gNKHPpo+wMBuKDCq8SFRvTh8NzWwAXgriSw1+BtltEdjZLVkI6NCk+i+r4hU9GkRIJEBnPzoxoNkJgk/rNhahgU+VHLQgHuaQeIR3S81U2cHycfvTHZTIHdFpivPf8yxDryN5Yl2opWSqr0Bq7OElN7z754HiTv5UL0iUmKmmRtXsBEBi1H16mkk/4fVgcGQVeZ7Gw37J9PKuJ3qtbYbUdIn2U8B9DZioQfQMoiQJhMMcnM4+J4xYMQ5i0N5KeMmDbiT7vqoCK5MBmE7mdcLkEzziutwBpVTLUxA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB4133.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6666004)(7416002)(4744005)(508600001)(86362001)(186003)(44832011)(6496006)(956004)(26005)(5660300002)(83380400001)(66556008)(36756003)(2616005)(6486002)(53546011)(6916009)(38100700002)(38350700002)(8676002)(66946007)(54906003)(66476007)(2906002)(316002)(52116002)(1076003)(4326008)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZlKcwTz/HSgatMpDnNxILVC/gfcYP4W4Z3dsc8sfdIILN04y+egjNB/pMIQE?=
 =?us-ascii?Q?jdPmUTGkT9fkMJOdzSew/a32DxX4+dv4I1dIkMYbJUhFypxruhuE1uNpnkkZ?=
 =?us-ascii?Q?PaBXs4RMH36nYxpRVDLtjiLN+lCwlZxE4oZ26u/tTOD9/k4Afmes5HH8nCPO?=
 =?us-ascii?Q?irmz276OASMwnT6TTJJtWvGJSIjJsEUZBb6yvGxPqsKaRDAgkA0UwS/03Y+W?=
 =?us-ascii?Q?fS99JWUp162TRF6eHu1cY44Kxuj/q0sV20xwrzlKPFohTes25E7zpcBSpfob?=
 =?us-ascii?Q?zTIMg9mg4gC0m4E7F0CTtRvajwVjNR+k2yAbgC6g4FW+KrGB5Zz7Z7i3Jx9h?=
 =?us-ascii?Q?qntFeT6c2eJE1fQnPDfIoJfXZ5YIbBVzpDRW1bq49v8kQiFtpuAd5vuj/HJp?=
 =?us-ascii?Q?z8TtJ/BM9ph3Cag2PP7N486EB1N8ayyc++2AZS5ywTv9DotOkSpeNDd2gPAl?=
 =?us-ascii?Q?1PN+zg58LqfE1XJrU1zSSR0D/P0PjJj0Yu478Da/CbMFJD3JGx5PwytnyMaK?=
 =?us-ascii?Q?KY4A0P7exCIkYRmdugDgOqssadh/7OnZa6cdJA3/lV01ZSn2zkDSekEtoF73?=
 =?us-ascii?Q?mKK3/v0taA5979qmRQAfBkzB6Ovees10x4WR0GI5j3W1bnLMaCLXP3DifIx8?=
 =?us-ascii?Q?Ugx/0f3LAgOZnu6fGQp8GjcyxO06AgauxU7nP8VcBwCbLO1caRTpQs1Op3SP?=
 =?us-ascii?Q?pXEQENJVMeGlEhogGvlpHF6ljGmgkWMCnJNHhk1e8T3zc+kqQ0OnrTLKQ54Q?=
 =?us-ascii?Q?EePhvdTsktinnFt7KSeayln7pDlxq47UUwrj2xI5MTXiG8xGXvHsq5gtj4Bb?=
 =?us-ascii?Q?k7R+jHX5MlqGGkyDKY248iBXyG0XfGJ+kXvRUBXJRasW5xTAD/KX68JTL6D/?=
 =?us-ascii?Q?OQnzWqlzNNNIa3D2Dntc2joVZ65PGpAVKZ74YW87ePlY/zRiynxEZdT+LvCD?=
 =?us-ascii?Q?v9JazSGM8xdQB22vVoO7vZV8OmOwRdFFVKXglW/XC5wDzp5T7W1JyuQlny3q?=
 =?us-ascii?Q?2IkcDktgO/Z/WIxb7xqBYFFC2ZrVru1tc6TGwwhXD7yGtQzpns0fbyw7n7uA?=
 =?us-ascii?Q?bR2AnHLR80m+eFRpAIxPcKXJeyMbrTNJRQZgn8bmH5EA+XLSeirLRHFkgGYK?=
 =?us-ascii?Q?nNen24IQFwhbWzS885yBx0vQe1svmZhJ6+MqpIsLOPiLP8JbpXf7urAf3Ne2?=
 =?us-ascii?Q?jFakynkmAWxJdQaSJeRVPVvwl9UdjhtvPgME+acsoA7jWo5q/ORYa2Yl4nUu?=
 =?us-ascii?Q?zP8u02qF/J8SopNHKI/y4Ucn5MYfWqUBtWaGcPLwgjDvqaTK/Lic4vVoRgPE?=
 =?us-ascii?Q?XmFxMuDRsBRMO1KUPnSeUKPY?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 587e5f88-3a6b-44fa-9169-08d9721f2ae4
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4133.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2021 16:47:24.0443
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cIUllRHSiA7hV1t+KxoO6VRNabv2me5lQQ4tsuuk/8qGHpqhtz1O/YybNituMfUHVcnKBcNMt4XwDl2nDogpzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3704
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 03, 2021 at 11:36:43PM +0300, Dov Murik wrote:
> Hi Michael,
> 
> On 27/08/2021 1:26, Michael Roth wrote:
> > From: Brijesh Singh <brijesh.singh@amd.com>
> > 
> > Sync the kvm.h with the kernel to include the SNP specific commands.
> > 
> > Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> > Signed-off-by: Michael Roth <michael.roth@amd.com>
> > ---
> >  linux-headers/linux/kvm.h | 50 +++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 50 insertions(+)
> > 
> 
> In previous review round I commented:
> 
> ------
> What about psp-sev.h ? I see that kernel patch "[PATCH Part2 RFC v4
> 11/40] crypto:ccp: Define the SEV-SNP commands" adds some new PSP return
> codes.
> 
> The QEMU user-friendly string list sev_fw_errlist (in sev.c) should be
> updated accordingly.
> -------

Sorry I missed that one, will include the header in the next round and update
the QEMU bits as suggested.

> 
> 
> -Dov
