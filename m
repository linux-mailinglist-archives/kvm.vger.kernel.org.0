Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64DA3326365
	for <lists+kvm@lfdr.de>; Fri, 26 Feb 2021 14:33:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbhBZNb7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Feb 2021 08:31:59 -0500
Received: from mail-mw2nam10on2080.outbound.protection.outlook.com ([40.107.94.80]:31981
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230106AbhBZNbZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Feb 2021 08:31:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PCRy1TPStn5SO3NeZTj1Alyc33aokyVNoTe/GO9DJLUYK4MEgMR22RiAahwb0/9tPkTKt+Wl6FfuaZcluaZYNwUZJjxKJNpwDDLuVTGFBNsCoCa5BkNurAb1zVP2aFIHLPryGd8yriIfpMDShQDAm7iAMfq7X40jBV+pof/GE6wwUfN/yb4MBU1x4q4vH2xOSwePrn8VEAFXrUVU6mAAQNFDvSoCRAK0LcWmDsQTxqtln4mIoRDuIsdEZyQuAKsAy7BM4QDVLpOsx1Cm/MW2/GS9p+/I6koFk4nhEFUegcheNxvbk92WGIDhtNMH+fJ9zfGZrDpkFNWYiQjJYKPcZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QMj97n3NfXHJABM7P0P3/M6LThg+eIecdJdjCXplb28=;
 b=amoCF3nPQuuYttWMjsCUqPTeNCwobRhn2ChonetqV32+b+6zDm0hQ7qtwauucy8sxSgcRbJv99trAAlpvrzNDG31Aq2jMUEcCA+yV3JzFFVCCgIi9OwQ14tnflIc6fumnkdUYZwWefOFmIOodIxOmWUPpiC1Mm1zNHoa38au7p7hOfovHf13xaT5PsjEz6cGZPT0eQj9CFXoI3cICC1h3vm6LnTocv9ltdL7pNL6HAA4lVJGckm0X1CpqJ8MXbER8dm8lQHLFIVNeQW/fzv7MWffkKz6Tc0qZ3+j76gtLgSyXKiMXtuYQFkYoILcL7Fm1L9OQP8Wbs1hYP9MhdDsTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QMj97n3NfXHJABM7P0P3/M6LThg+eIecdJdjCXplb28=;
 b=ZcrYTuroA5HoQrtIuSSZKWK5E9a8vBpvjVpVqwqdkuGvybYBZcBpCBfWLkAzsFxTzlv6ebPMkNnNW+ekW0CIRuEEkAbNSm896/Z2jqfQGGBM6pzQp23aR3/uaWzHJN1/SGZTgC5y0j9gF9rOTKm5chHLAFlh3foWmPABMmcIvRg=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4575.namprd12.prod.outlook.com (2603:10b6:806:73::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.20; Fri, 26 Feb
 2021 13:30:32 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e%7]) with mapi id 15.20.3890.020; Fri, 26 Feb 2021
 13:30:32 +0000
Date:   Fri, 26 Feb 2021 13:30:23 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        natet@google.com, brijesh.singh@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, rientjes@google.com,
        seanjc@google.com, srutherford@google.com, thomas.lendacky@amd.com,
        x86@kernel.org, Tobin Feldman-Fitzthum <tobin@ibm.com>,
        DOV MURIK <Dov.Murik1@il.ibm.com>
Subject: Re: [RFC] KVM: x86: Support KVM VMs sharing SEV context
Message-ID: <20210226133023.GA5950@ashkalra_ubuntu_server>
References: <20210224085915.28751-1-natet@google.com>
 <7cb132ce522728f7689618832a65e31e37788201.camel@HansenPartnership.com>
 <20210225181812.GA5046@ashkalra_ubuntu_server>
 <b885c283-ceb3-b9bc-516b-c28771652a7c@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b885c283-ceb3-b9bc-516b-c28771652a7c@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA9PR13CA0038.namprd13.prod.outlook.com
 (2603:10b6:806:22::13) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by SA9PR13CA0038.namprd13.prod.outlook.com (2603:10b6:806:22::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.10 via Frontend Transport; Fri, 26 Feb 2021 13:30:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ed921b6e-ab1f-4f0b-7a44-08d8da5aaf9f
X-MS-TrafficTypeDiagnostic: SA0PR12MB4575:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB45752129EC1B6877856291338E9D9@SA0PR12MB4575.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XZxgOoMr49iOI7zcECP+uauoqA4hOUyn5pbu4byBKjjj7Kc6JyIMm+1hsmP2e65a+T3xrME96CJiHvINFhe5TjKRRV9g8D7EtaXo4vf1q0w5AnBAGel7/sUCIGV58mE8tv6s/IkRrCE7CJnyy9z+9Tf6aXXEVjxiZNIuYTd158/lAf2oZH/dNGuVxf881DCH47pLiaI2ciKVjhNTn5bzOZEaQxlmPvWtJYWSTdiR/o612KGlcyuFit4NeI6ceEwv+yOKbtLw8SdpcgtGphzEMZ/6GpW+1tIRvVO21KsJ7Vjwf7TJTKpj6r+bqzysvjnieDpOOsuQTKBMG04H17xfIaWF4J/9PiR+YzNiVHiSXgEf8tgyUigrhF8rT9csgeX1A2xMrqXjNHL8iirH/EQhc/f7x0ej9uSozww/HFFO57Ej2yZGEIfUUf0Ozp9AAoUZYQCjRRvS5e4JMpmVrIlgxjoADUQa8+SZdPeHKfx/UNH1a1lnzzA9sEiqCl0ExzaZowrk63/m6ZRkco/pjJGQnQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(396003)(376002)(366004)(346002)(54906003)(16526019)(53546011)(6496006)(8936002)(186003)(9686003)(316002)(44832011)(8676002)(52116002)(956004)(26005)(478600001)(66946007)(66556008)(6916009)(86362001)(66476007)(2906002)(33656002)(4744005)(4326008)(7416002)(33716001)(6666004)(1076003)(55016002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?9Ozl5r8ZetPAG+lSKVRV1OXK/aVkQrw0T0ySkpqyK6+0NYOnpWQb5mvy3Yrw?=
 =?us-ascii?Q?dg4DM42wOp4wXGiQwCz7mUTyZOxeuDUJi/eB83pezMqcPMKQwCWay9V80z9E?=
 =?us-ascii?Q?DW54ldC6g6g68GDzoa36WAk+7YgFLgbua0tZrkDKNb1lm53bHVH3Bo/g91Zk?=
 =?us-ascii?Q?bHBN9zWx+tHpAXk2WqoCC1mz9RIAgdPxxrsz/fDBcq1rHN82B8hMdpo3sMjR?=
 =?us-ascii?Q?FZgtAze2lKGXAxd1ZuBvbECogdd723A/3NWmQjiYgm+8Gr9JG7VmfzX7xxV/?=
 =?us-ascii?Q?ycVLNCmAXyVV9bkveTcUJIAYDnI3tUqzAmDKL96b2HBFsEOCGwbZuIg5yirT?=
 =?us-ascii?Q?O/ErmQwu5YklhdztYKFM9dzZMFQv4z3nElnB+TYwRkiI+d0s46RmqBIdoIxl?=
 =?us-ascii?Q?AxZYLhM6Q2R9r3Lt7YoaaR/UVu/QDFk+X1FzkspjscrdlcGjDeibzRliqpQQ?=
 =?us-ascii?Q?AW3mGLE+PfPOFPEwyyAKqwp8i0rswMdPJ8n8SJFlIQcNMmEG3V02TPZX+Q/a?=
 =?us-ascii?Q?X2S/Hs0Idrm0/dfh3NgDt+byR+aA6fre09ql27daU+2QC8iUS5cBzFa3qv0/?=
 =?us-ascii?Q?vmm5zv3qrpMDkmSonvadprLZFZYAaLHJPXUk6x6nZUwaFHGxD5lCv3WY4SYO?=
 =?us-ascii?Q?J+gpXrt43c3molImmekl6xgHIGY5M3XA3fDuyzDTgNjhMsunRPBKi6yOhF5R?=
 =?us-ascii?Q?/7LcS64tCxnvz3WWT6ZT/OYihLNkVZcr+9UmY+yhrGGZbvmEVMTxRSx01v4q?=
 =?us-ascii?Q?W7LV2euw4UklCI/GZZg86TipHDcsI2eh/NeOeXRd/Wu4CSR5ozYCV6YE83hY?=
 =?us-ascii?Q?rNEAE1qFUHD2g4F9TNcB3D188fHBGYByoTCuNceNIdFnze06Kx1Dj8J4PLv3?=
 =?us-ascii?Q?KashvZtcu++DMMy2MGsZq+PKjkPqpCKwXdIk3N+8QAvKnpbnvS42Ei44oIpZ?=
 =?us-ascii?Q?tICCK0NH7/YWM8giKYHKm7fetXfgYaLQJpT0qpd5J8txG6lS4erP5jKz7MUp?=
 =?us-ascii?Q?Jtiht9Gl/nXHmYFntmOVCp05LUPr0Kct6kVe2PheJ/kZAMYAXf9SjPzzHEcZ?=
 =?us-ascii?Q?R5wDtwalx65mDHhoKev5oJ9Hpm0R9vYX6h9C3Bq31VpL1w2uNGjyrW2gjrj3?=
 =?us-ascii?Q?AbyPTL2/LOdn0T4A3NYsPxGGkC8F1gz2RJisj4OZ2fgiPHsdC8cErcWBCsaT?=
 =?us-ascii?Q?1PoMLu0rZADJIS64jPULty2j60Oid7O1/+JOYl6/t6gTvF2crTOCLSCEwiuD?=
 =?us-ascii?Q?XhHueWNJmZIIVBoRO2mALFOg3nEybJlICVbiqp5/e4rKEjrh5YQWKyBpjqci?=
 =?us-ascii?Q?p0Kk5PRZ9gBkg9HOylc6Qk0f?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed921b6e-ab1f-4f0b-7a44-08d8da5aaf9f
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2021 13:30:31.8051
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jaRIvVIbb/k4kCIhbcijoFMYhd+O6lkPvNtaAYWN3Dw+2wkogjTqW1T8kWqDu0XSEk7Ve6pA8ed1ijyjBPegKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4575
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 25, 2021 at 09:33:09PM +0100, Paolo Bonzini wrote:
> On 25/02/21 19:18, Ashish Kalra wrote:
> > I do believe that some of these alternative SEV live migration support
> > or Migration helper (MH) solutions will still use SEV PSP migration for
> > migrating the MH itself, therefore the SEV live migration patches
> > (currently v10 posted upstream) still make sense and will be used.
> 
> I think that since the migration helper (at least for SEV, not -ES) is part
> of the attested firmware, it can be started on the destination before the
> rest of the VM.
> 

We may also need to transport VMSA(s) securely using the PSP migration
support for SEV-ES live migration with MH.

Thanks,
Ashish
