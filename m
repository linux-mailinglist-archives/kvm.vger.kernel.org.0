Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EADF402D12
	for <lists+kvm@lfdr.de>; Tue,  7 Sep 2021 18:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344728AbhIGQsY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Sep 2021 12:48:24 -0400
Received: from mail-co1nam11on2054.outbound.protection.outlook.com ([40.107.220.54]:32480
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237130AbhIGQsX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Sep 2021 12:48:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R6Bk9/LqZ0WOjUeWI8dtc4P5fXP6jkEPcwHAOBMnoy4/jB14T/H9snGudp1RvKSZFINpY6OMwExkWnk3QZaiU3h91qoPmcGSV2/ZUkCh1iNwGHrpUclky766wmrg/MfAFSyrSiTmf+wdxjM15fTkqtpMp4vOPD6AKKhELuPotE1AB1xefsl6yDeO+zSeuZ7seDblQRR+W4O4FJ6UtE6MTFsICBEEIJBxOurUfkaGUko67wNd9CKziEJK9AO6PN1iCLzPzNJ2XjY7cBo+CaNIsjNZH0bnGtjcCYYHbYvVl45D9lpCCu5Pr0wWXBt6agUtxfGvLIHkMJqkpLFad5sh1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=aKLLZB0nvgarmkhHAOlnML0SU0UVMdnkpq8CaB0YxEE=;
 b=PJv6Im//CMkcloNs60C80MXBJ5mFDemke0jmXdJKm9dOgIvegwCfcUc/RxMBuTceHU+5VrMVCz522Ed1UhJayMxbabQwn7gFiQwtViKLx2iU/KUeL+y1U6m6BMxUTaVHu8Kw8NvuAkRNyarPYq2mUUuUIbYKWTD2I9KH+4rb5R4ralvehG8RbYfKVrSceku02d7WWn5SBYKyV1gAPOqVXqHOopNxY3+x2sraNau/9ofOHS26UyvDuD/l0/usMSCig/okVXBX2fKrzhRN+t+GgZKvc4J/jZSwvIZZ/AvefYs1Rvtv8ASru44pGdCewuniWQRhKDpLRczCmrBr8rz6uQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aKLLZB0nvgarmkhHAOlnML0SU0UVMdnkpq8CaB0YxEE=;
 b=cChZXQRFjtPpYHS8l14MAW11LeRDSxDVEotybkDbtzE6T5h5Mmu91j4JXBpFpc6l1CR+Td1eDYVyxBhlC/peLx/wVJahPH1GNwUVyoMsNxWVXKo0bSn2oRKEfh9VCdJz2g+YABRfoeTvtEQrvmSssVsYNXrNdrznsVbjbdqi70w=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=amd.com;
Received: from CH2PR12MB4133.namprd12.prod.outlook.com (2603:10b6:610:7a::13)
 by CH2PR12MB4280.namprd12.prod.outlook.com (2603:10b6:610:ac::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19; Tue, 7 Sep
 2021 16:47:15 +0000
Received: from CH2PR12MB4133.namprd12.prod.outlook.com
 ([fe80::f5af:373a:5a75:c353]) by CH2PR12MB4133.namprd12.prod.outlook.com
 ([fe80::f5af:373a:5a75:c353%6]) with mapi id 15.20.4478.025; Tue, 7 Sep 2021
 16:47:15 +0000
Date:   Tue, 7 Sep 2021 09:20:33 -0500
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
Subject: Re: [RFC PATCH v2 03/12] i386/sev: introduce 'sev-snp-guest' object
Message-ID: <20210907142033.ewqscynvdni63xk7@amd.com>
References: <20210826222627.3556-1-michael.roth@amd.com>
 <20210826222627.3556-4-michael.roth@amd.com>
 <1efdd7a3-b712-06a1-90e1-7ca8134f5506@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1efdd7a3-b712-06a1-90e1-7ca8134f5506@linux.ibm.com>
X-ClientProxiedBy: SN4PR0501CA0137.namprd05.prod.outlook.com
 (2603:10b6:803:2c::15) To CH2PR12MB4133.namprd12.prod.outlook.com
 (2603:10b6:610:7a::13)
MIME-Version: 1.0
Received: from localhost (76.251.165.188) by SN4PR0501CA0137.namprd05.prod.outlook.com (2603:10b6:803:2c::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.6 via Frontend Transport; Tue, 7 Sep 2021 16:47:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6dea06e6-1926-42fe-7c86-08d9721f255e
X-MS-TrafficTypeDiagnostic: CH2PR12MB4280:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CH2PR12MB428007B3F7C9917E2928D3C495D39@CH2PR12MB4280.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GXXUhmg0tEa5fxRPFwgJZBbqZ9DFHvyxWPgzWcex9lzWj3Le63nXmiGUm8yCsHSauvsoDAfrA0UhLHkBUW9rzgB2fYxR3QIzJoWPZbzlnaS+QeLsseuoLMGqa/g0s0C+fd+0DaFlzCcl3frvujClX6UeDjNXPemyHLnQtwL7BAPUEqlUfZ/ZAd78AHr+5OXP9rilHBiegCtIjMRV1ALHurMP2XdLo1EMWisHyFzbmpLGudaPugO/ygKPl2rvZw7gQ0WYIjhcFN6k3UQj1TWybhMMoz023aOtIHzSvYOi5X1ncG84YCEGJBuxQE+asEplO96OQHWIlt+9WYS2oDPiadokMVlBnhWXTo4DW7Ni4qAsBFWddsJhakbgIgCFx8tGPO9hcBJoHQe4RPrX1/80IKoDL9ZJ8d7ASN2Qvr4gplaUHDf18qtaGISxjphCGvtXicxDA6Jmf2vmN3YigjrgjKkhwaePGck98SW6nDNW8Ts3jsVADdsQ7rCto4bUfzUIJMvDhwc32koXYpVzpoNrYc2bWivtKRJnF+aCWVVcxR56YRfDRtn4rfefUK9xnHrjRe8azCHXu0w5VGs2heU9yrT30EjcLQ94baXmFhCbiToAPjgdvjKIAmgWSB0Z0WRCBcAoXO1q2x8wr3Gaj6fhJfGfXrOf5kgFGrh8lJ2Gc14LtDUE1GqYPbKI39fAme/IyXyh2/Wy0hrSum06RnW9hA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB4133.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(39860400002)(136003)(346002)(396003)(6486002)(2906002)(26005)(66946007)(38100700002)(8936002)(86362001)(6496006)(7416002)(5660300002)(52116002)(4326008)(66476007)(8676002)(30864003)(66556008)(1076003)(53546011)(478600001)(54906003)(36756003)(2616005)(956004)(83380400001)(44832011)(6666004)(316002)(186003)(6916009)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uSnI4JEdZdPEu+WFklmo2eK+GCKujqIPn6jreLKeh6hTAPrPAm7xmF2YaE+t?=
 =?us-ascii?Q?7kH0IDThVJpTybDnj4RYUupXz9mzkfLUoqicz2TDzYKS+BhK+qcfCOiiQuPN?=
 =?us-ascii?Q?y0O9Lkzge6FDLnzbeH0DKvVa42JU107ieS+31uUwveXec4YxKWUcL10tyK6V?=
 =?us-ascii?Q?Tlyq8qKCN5RIYOA238Wgr5glQKX7i6sXJdw1XE8QGrMmLfUbWws+3k0Vguqy?=
 =?us-ascii?Q?ehvaiozqyjVBY1qKPzziClEUaD9ggLCQ4ojkifhI5ucHaew73t6H64iuI+AO?=
 =?us-ascii?Q?CunSbcJ6aTOHESSBjf4vafo4rztsNOcKMLsXcOaH3ccti/4U6eAQn/KzxYYf?=
 =?us-ascii?Q?P/cnZIwvgZMr5d8YzWYPEyTHdWoAsDNDEu8I5kmiOCZrbUN2om2XCdncQeJr?=
 =?us-ascii?Q?po2HF4gftsHxJa8B02RM/6z1czsTcfkkRV8pj8u1qrPXipUK9nAiOFkUx8UV?=
 =?us-ascii?Q?x165jK8mmDgwrWFRnzpBqcmI7he0c9FucpNKmbP5987UWWIe4S+x+83tchaE?=
 =?us-ascii?Q?ooHTrLaGJlf1E+cPBkZXMb8nQZpwKAj0CjCf54bJ5mU1ptLyBzfjzPxvC+jC?=
 =?us-ascii?Q?ypsIqT+u2qVe06c9fFoVhXinOYYh3pzmnezlO64RlXwNfXQc58VqegZ1zJl7?=
 =?us-ascii?Q?qkRnFfczLBKmhXCRuX951+RssA9K0YQi6OvBoUKrqmmuFqi9yLKCIHErb+cX?=
 =?us-ascii?Q?VD2Ly4WcUl0GyHzYHGRkcMKMpRhakHQdg3MYQxIlTBYXNlBticYPIQMkXRJe?=
 =?us-ascii?Q?LT4b/03/eYUgevSXTs6WU7HBi4dhlklhQKPtSubRrnGLEeCaEuoEBgYGf0JN?=
 =?us-ascii?Q?Zm/FrwphkNe+eJaflsqncd845m+Ja5GBZ1R01Egcqi+P7ELIWXXNe7RH4zdM?=
 =?us-ascii?Q?0IR0NnsAf+jbA/IC/p+seCFWOOE7nIzozT8opxcd9wlASxK3gLBByLLDzwDB?=
 =?us-ascii?Q?98uFly10hRvqOJeZ8+QRR5T2JvxqpX+H198naJc7B2vTWnf0fnT/9iTrI8Ys?=
 =?us-ascii?Q?Fq9nCIKdORFztvclyELwwWFp/fBv88zpJee5aPlgI9o9fl8vlmq7etgih9kj?=
 =?us-ascii?Q?nZnmO0eoEU7QQjdRmRaqcDhgv3BkYEcq0kQgAzN0CccGXo/oDglvbNK7DHhs?=
 =?us-ascii?Q?rNJOtZqH03SCXsFGjP9oDu8NvMusxTpsrn+jS8u5ub8U5wIErBD1aHRG7BDh?=
 =?us-ascii?Q?ONdfJBjyiX5jTe4VJE+fGRyqQ996PfUaB50b4Kw3O+yutzGMDcEoxzxnu3eF?=
 =?us-ascii?Q?0MCrm9ZPXj/nZGQmRTnBRZQQ8LtmGmLe+NzKHS9rUqmToZzqJVCoU7TfagJU?=
 =?us-ascii?Q?+kRglE8198/3nqYqjuAjhusH?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6dea06e6-1926-42fe-7c86-08d9721f255e
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4133.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2021 16:47:14.9941
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OH7v4vc1XzoEoTy75ffMQhiVjAdTsp+h68zOrP6IZGUZ5/4H4w4FePr4fUO0CQw1Otg+KHxrJjmGni+G7x24CQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4280
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Sep 04, 2021 at 12:12:19AM +0300, Dov Murik wrote:
> 
> 
> On 27/08/2021 1:26, Michael Roth wrote:
> > From: Brijesh Singh <brijesh.singh@amd.com>
> > 
> > SEV-SNP support relies on a different set of properties/state than the
> > existing 'sev-guest' object. This patch introduces the 'sev-snp-guest'
> > object, which can be used to configure an SEV-SNP guest. For example,
> > a default-configured SEV-SNP guest with no additional information
> > passed in for use with attestation:
> > 
> >   -object sev-snp-guest,id=sev0
> > 
> > or a fully-specified SEV-SNP guest where all spec-defined binary
> > blobs are passed in as base64-encoded strings:
> > 
> >   -object sev-snp-guest,id=sev0, \
> >     policy=0x30000, \
> >     init-flags=0, \
> >     id-block=YWFhYWFhYWFhYWFhYWFhCg==, \
> >     id-auth=CxHK/OKLkXGn/KpAC7Wl1FSiisWDbGTEKz..., \
> >     auth-key-enabled=on, \
> >     host-data=LNkCWBRC5CcdGXirbNUV1OrsR28s..., \
> >     guest-visible-workarounds=AA==, \
> > 
> > See the QAPI schema updates included in this patch for more usage
> > details.
> > 
> > In some cases these blobs may be up to 4096 characters, but this is
> > generally well below the default limit for linux hosts where
> > command-line sizes are defined by the sysconf-configurable ARG_MAX
> > value, which defaults to 2097152 characters for Ubuntu hosts, for
> > example.
> > 
> > Co-developed-by: Michael Roth <michael.roth@amd.com>
> > Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> > Signed-off-by: Michael Roth <michael.roth@amd.com>
> > ---
> >  docs/amd-memory-encryption.txt |  77 ++++++++++-
> >  qapi/qom.json                  |  60 ++++++++
> >  target/i386/sev.c              | 245 ++++++++++++++++++++++++++++++++-
> >  3 files changed, 379 insertions(+), 3 deletions(-)
> > 
> > diff --git a/docs/amd-memory-encryption.txt b/docs/amd-memory-encryption.txt
> > index ffca382b5f..0d82e67fa1 100644
> > --- a/docs/amd-memory-encryption.txt
> > +++ b/docs/amd-memory-encryption.txt
> > @@ -22,8 +22,8 @@ support for notifying a guest's operating system when certain types of VMEXITs
> >  are about to occur. This allows the guest to selectively share information with
> >  the hypervisor to satisfy the requested function.
> >  
> > -Launching
> > ----------
> > +Launching (SEV and SEV-ES)
> > +--------------------------
> >  Boot images (such as bios) must be encrypted before a guest can be booted. The
> >  MEMORY_ENCRYPT_OP ioctl provides commands to encrypt the images: LAUNCH_START,
> >  LAUNCH_UPDATE_DATA, LAUNCH_MEASURE and LAUNCH_FINISH. These four commands
> > @@ -113,6 +113,79 @@ a SEV-ES guest:
> >   - Requires in-kernel irqchip - the burden is placed on the hypervisor to
> >     manage booting APs.
> >  
> > +Launching (SEV-SNP)
> > +-------------------
> > +Boot images (such as bios) must be encrypted before a guest can be booted. The
> > +MEMORY_ENCRYPT_OP ioctl provides commands to encrypt the images:
> > +KVM_SNP_INIT, SNP_LAUNCH_START, SNP_LAUNCH_UPDATE, and SNP_LAUNCH_FINISH. These
> > +four commands together generate a fresh memory encryption key for the VM,
> > +encrypt the boot images for a successful launch.
> > +
> > +KVM_SNP_INIT is called first to initialize the SEV-SNP firmware and SNP
> > +features in the KVM. The feature flags value can be provided through the
> > +'init-flags' property of the 'sev-snp-guest' object.
> > +
> > ++------------+-------+----------+---------------------------------+
> > +| key        | type  | default  | meaning                         |
> > ++------------+-------+----------+---------------------------------+
> > +| init_flags | hex   | 0        | SNP feature flags               |
> > ++-----------------------------------------------------------------+
> > +
> > +Note: currently the init_flags must be zero.
> > +
> > +SNP_LAUNCH_START is called first to create a cryptographic launch context
> > +within the firmware. To create this context, guest owner must provide a guest
> > +policy and other parameters as described in the SEV-SNP firmware
> > +specification. The launch parameters should be specified as described in the
> > +QAPI schema for the 'sev-snp-guest' object.
> > +
> > +The SNP_LAUNCH_START uses the following parameters (see the SEV-SNP
> > +specification for more details):
> > +
> > ++--------+-------+----------+----------------------------------------------+
> > +| key    | type  | default  | meaning                                      |
> > ++--------+-------+----------+----------------------------------------------+
> > +| policy | hex   | 0x30000  | a 64-bit guest policy                        |
> > +| imi_en | bool  | 0        | 1 when IMI is enabled                        |
> > +| ma_end | bool  | 0        | 1 when migration agent is used               |
> > +| gosvw  | string| 0        | 16-byte base64 encoded string for the guest  |
> > +|        |       |          | OS visible workaround.                       |
> > ++--------+-------+----------+----------------------------------------------+
> > +
> > +SNP_LAUNCH_UPDATE encrypts the memory region using the cryptographic context
> > +created via the SNP_LAUNCH_START command. If required, this command can be called
> > +multiple times to encrypt different memory regions. The command also calculates
> > +the measurement of the memory contents as it encrypts.
> > +
> > +SNP_LAUNCH_FINISH finalizes the guest launch flow. Optionally, while finalizing
> > +the launch the firmware can perform checks on the launch digest computing
> > +through the SNP_LAUNCH_UPDATE. To perform the check the user must supply
> > +the id block, authentication blob and host data that should be included in the
> > +attestation report. See the SEV-SNP spec for further details.
> > +
> > +The SNP_LAUNCH_FINISH uses the following parameters, which can be configured
> > +by the corresponding parameters documented in the QAPI schema for the
> > +'sev-snp-guest' object.
> > +
> > ++------------+-------+----------+----------------------------------------------+
> > +| key        | type  | default  | meaning                                      |
> > ++------------+-------+----------+----------------------------------------------+
> > +| id_block   | string| none     | base64 encoded ID block                      |
> > ++------------+-------+----------+----------------------------------------------+
> > +| id_auth    | string| none     | base64 encoded authentication information    |
> > ++------------+-------+----------+----------------------------------------------+
> > +| auth_key_en| bool  | 0        | auth block contains author key               |
> > ++------------+-------+----------+----------------------------------------------+
> > +| host_data  | string| none     | host provided data                           |
> > ++------------+-------+----------+----------------------------------------------+
> > +
> > +To launch a SEV-SNP guest (additional parameters are documented in the QAPI
> > +schema for the 'sev-snp-guest' object):
> > +
> > +# ${QEMU} \
> > +    -machine ...,confidential-guest-support=sev0 \
> > +    -object sev-snp-guest,id=sev0,cbitpos=51,reduced-phys-bits=1
> > +
> >  Debugging
> >  -----------
> >  Since the memory contents of a SEV guest are encrypted, hypervisor access to
> > diff --git a/qapi/qom.json b/qapi/qom.json
> > index 211e083727..ea39585026 100644
> > --- a/qapi/qom.json
> > +++ b/qapi/qom.json
> > @@ -775,6 +775,64 @@
> >              '*policy': 'uint32',
> >              '*handle': 'uint32' } }
> >  
> > +##
> > +# @SevSnpGuestProperties:
> > +#
> > +# Properties for sev-snp-guest objects. Many of these are direct arguments
> > +# for the SEV-SNP KVM interfaces documented in the linux kernel source
> > +# documentation under 'amd-memory-encryption.rst'. Additional documentation
> > +# is also available in the QEMU source tree under
> > +# 'amd-memory-encryption.rst'.
> > +#
> > +# In addition to those files, please see the SEV-SNP Firmware Specification
> > +# (Rev 0.9) documentation for the SNP_INIT and
> > +# SNP_LAUNCH_{START,UPDATE,FINISH} firmware interfaces, which the KVM
> > +# interfaces are written against.
> > +#
> > +# @init-flags: as documented for the 'flags' parameter of the
> > +#              KVM_SNP_INIT KVM command (default: 0)
> > +#
> > +# @policy: as documented for the 'policy' parameter of the
> > +#          KVM_SNP_LAUNCH_START KVM command (default: 0x30000)
> > +#
> > +# @guest-visible-workarounds: 16-byte, base64-encoded blob to report
> > +#                             hypervisor-defined workarounds, as documented
> > +#                             for the 'gosvm' parameter of the
> 
> typo: s/gosvm/gosvw/

Argh, can't seem to get that one right!

> 
> 
> > +#                             KVM_SNP_LAUNCH_START KVM command.
> > +#                             (default: all-zero)
> > +#
> > +# @id-block: 8-byte, base64-encoded blob to provide the ID Block
> > +#            structure documented in SEV-SNP spec, as documented for the
> > +#            'id_block_uaddr' parameter of the KVM_SNP_LAUNCH_FINISH
> > +#            command (default: all-zero)
> 
> The documentation says the ID Block is 96 bytes long (Table 65 in
> section 8.15 of the SNP FW ABI document).

Thanks for the catch, I think I grabbed the value from the wrong column here.

> 
> 
> > +#
> > +# @id-auth: 4096-byte, base64-encoded blob to provide the ID Authentication
> > +#           Information Structure documented in SEV-SNP spec, as documented
> > +#           for the 'id_auth_uaddr' parameter of the KVM_SNP_LAUNCH_FINISH
> > +#           command (default: all-zero)
> > +#
> > +# @auth-key-enabled: true if 'id-auth' blob contains the Author Key
> > +#                    documented in the SEV-SNP spec, as documented for the
> > +#                    'auth_key_en' parameter of the KVM_SNP_LAUNCH_FINISH
> > +#                    command (default: false)
> > +#
> > +# @host-data: 32-byte, base64-encoded user-defined blob to provide to the
> > +#             guest, as documented for the 'host_data' parameter of the
> > +#             KVM_SNP_LAUNCH_FINISH command (default: all-zero)
> > +#
> > +# Since: 6.2
> > +##
> > +{ 'struct': 'SevSnpGuestProperties',
> > +  'base': 'SevCommonProperties',
> > +  'data': {
> > +            '*init-flags': 'uint64',
> > +            '*policy': 'uint64',
> > +            '*guest-visible-workarounds': 'str',
> > +            '*id-block': 'str',
> > +            '*id-auth': 'str',
> > +            '*auth-key-enabled': 'bool',
> > +            '*host-data': 'str' } }
> > +
> >  ##
> >  # @ObjectType:
> >  #
> > @@ -816,6 +874,7 @@
> >      'secret',
> >      'secret_keyring',
> >      'sev-guest',
> > +    'sev-snp-guest',
> >      's390-pv-guest',
> >      'throttle-group',
> >      'tls-creds-anon',
> > @@ -873,6 +932,7 @@
> >        'secret':                     'SecretProperties',
> >        'secret_keyring':             'SecretKeyringProperties',
> >        'sev-guest':                  'SevGuestProperties',
> > +      'sev-snp-guest':              'SevSnpGuestProperties',
> >        'throttle-group':             'ThrottleGroupProperties',
> >        'tls-creds-anon':             'TlsCredsAnonProperties',
> >        'tls-creds-psk':              'TlsCredsPskProperties',
> > diff --git a/target/i386/sev.c b/target/i386/sev.c
> > index 6acebfbd53..ba08b7d3ab 100644
> > --- a/target/i386/sev.c
> > +++ b/target/i386/sev.c
> > @@ -38,7 +38,8 @@
> >  OBJECT_DECLARE_SIMPLE_TYPE(SevCommonState, SEV_COMMON)
> >  #define TYPE_SEV_GUEST "sev-guest"
> >  OBJECT_DECLARE_SIMPLE_TYPE(SevGuestState, SEV_GUEST)
> > -
> > +#define TYPE_SEV_SNP_GUEST "sev-snp-guest"
> > +OBJECT_DECLARE_SIMPLE_TYPE(SevSnpGuestState, SEV_SNP_GUEST)
> >  
> >  /**
> >   * SevGuestState:
> > @@ -82,8 +83,23 @@ struct SevGuestState {
> >      char *session_file;
> >  };
> >  
> > +struct SevSnpGuestState {
> > +    SevCommonState sev_common;
> > +
> > +    /* configuration parameters */
> > +    char *guest_visible_workarounds;
> > +    char *id_block;
> > +    char *id_auth;
> > +    char *host_data;
> > +
> > +    struct kvm_snp_init kvm_init_conf;
> > +    struct kvm_sev_snp_launch_start kvm_start_conf;
> > +    struct kvm_sev_snp_launch_finish kvm_finish_conf;
> > +};
> > +
> >  #define DEFAULT_GUEST_POLICY    0x1 /* disable debug */
> >  #define DEFAULT_SEV_DEVICE      "/dev/sev"
> > +#define DEFAULT_SEV_SNP_POLICY  0x30000
> >  
> >  #define SEV_INFO_BLOCK_GUID     "00f771de-1a7e-4fcb-890e-68c77e2fb44e"
> >  typedef struct __attribute__((__packed__)) SevInfoBlock {
> > @@ -364,6 +380,232 @@ static const TypeInfo sev_guest_info = {
> >      .class_init = sev_guest_class_init,
> >  };
> >  
> > +static void
> > +sev_snp_guest_get_init_flags(Object *obj, Visitor *v, const char *name,
> > +                             void *opaque, Error **errp)
> > +{
> > +    visit_type_uint64(v, name,
> > +                      (uint64_t *)&SEV_SNP_GUEST(obj)->kvm_init_conf.flags,
> > +                      errp);
> > +}
> > +
> > +static void
> > +sev_snp_guest_set_init_flags(Object *obj, Visitor *v, const char *name,
> > +                             void *opaque, Error **errp)
> > +{
> > +    visit_type_uint64(v, name,
> > +                      (uint64_t *)&SEV_SNP_GUEST(obj)->kvm_init_conf.flags,
> > +                      errp);
> > +}
> > +
> > +static void
> > +sev_snp_guest_get_policy(Object *obj, Visitor *v, const char *name,
> > +                         void *opaque, Error **errp)
> > +{
> > +    visit_type_uint64(v, name,
> > +                      (uint64_t *)&SEV_SNP_GUEST(obj)->kvm_start_conf.policy,
> > +                      errp);
> > +}
> > +
> > +static void
> > +sev_snp_guest_set_policy(Object *obj, Visitor *v, const char *name,
> > +                         void *opaque, Error **errp)
> > +{
> > +    visit_type_uint64(v, name,
> > +                      (uint64_t *)&SEV_SNP_GUEST(obj)->kvm_start_conf.policy,
> > +                      errp);
> > +}
> > +
> > +static char *
> > +sev_snp_guest_get_guest_visible_workarounds(Object *obj, Error **errp)
> > +{
> > +    return g_strdup(SEV_SNP_GUEST(obj)->guest_visible_workarounds);
> > +}
> > +
> > +static void
> > +sev_snp_guest_set_guest_visible_workarounds(Object *obj, const char *value,
> > +                                            Error **errp)
> > +{
> > +    SevSnpGuestState *sev_snp_guest = SEV_SNP_GUEST(obj);
> > +    struct kvm_sev_snp_launch_start *start = &sev_snp_guest->kvm_start_conf;
> > +    g_autofree guchar *blob;
> > +    gsize len;
> > +
> > +    if (sev_snp_guest->guest_visible_workarounds) {
> > +        g_free(sev_snp_guest->guest_visible_workarounds);
> > +    }
> > +
> > +    /* store the base64 str so we don't need to re-encode in getter */
> > +    sev_snp_guest->guest_visible_workarounds = g_strdup(value);
> > +
> > +    blob = g_base64_decode(sev_snp_guest->guest_visible_workarounds, &len);
> 
> I see there's a qbase64_decode which performs some checks and then calls
> g_base64_decode.  It might detect illegal chars in the value?

That does seems to be the preferred approach, I'll switch to that for
the series.

> 
> Also I think you should verify this decode succeeds by checking that
> blob is not NULL.
> 
> (similar comments for all base64_decode calls in this file.)

I'll add those checks as well.

> 
> 
> > +    if (len > sizeof(start->gosvw)) {
> > +        error_setg(errp, "parameter length of %lu exceeds max of %lu",
> > +                   len, sizeof(start->gosvw));
> > +        return;
> > +    }
> > +
> > +    memcpy(start->gosvw, blob, len);
> > +}
> > +
> > +static char *
> > +sev_snp_guest_get_id_block(Object *obj, Error **errp)
> > +{
> > +    SevSnpGuestState *sev_snp_guest = SEV_SNP_GUEST(obj);
> > +
> > +    return g_strdup(sev_snp_guest->id_block);
> > +}
> > +
> > +static void
> > +sev_snp_guest_set_id_block(Object *obj, const char *value, Error **errp)
> > +{
> > +    SevSnpGuestState *sev_snp_guest = SEV_SNP_GUEST(obj);
> > +    struct kvm_sev_snp_launch_finish *finish = &sev_snp_guest->kvm_finish_conf;
> > +    gsize len;
> > +
> > +    if (sev_snp_guest->id_block) {
> > +        g_free(sev_snp_guest->id_block);
> > +        g_free((guchar *)finish->id_block_uaddr);
> > +    }
> > +
> > +    /* store the base64 str so we don't need to re-encode in getter */
> > +    sev_snp_guest->id_block = g_strdup(value);
> > +
> > +    finish->id_block_uaddr = (uint64_t)g_base64_decode(sev_snp_guest->id_block, &len);
> > +    if (len > KVM_SEV_SNP_ID_BLOCK_SIZE) {
> > +        error_setg(errp, "parameter length of %lu exceeds max of %u",
> > +                   len, KVM_SEV_SNP_ID_BLOCK_SIZE);
> > +        return;
> > +    }
> > +    finish->id_block_en = 1;
> 
> There's no way to set the id_block to a "don't want an ID block", except
> for not giving this option to the sev-snp-guest object.  I'm not sure if
> this is a problem (for example, if you dump one VM's config and try to
> load it elsewhere).
> 
> Maybe if strlen(value)==0 you should set finish->id_block_en = 0.

That makes sense, I'll add the handling for this.
