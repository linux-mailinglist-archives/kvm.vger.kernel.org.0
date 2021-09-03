Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D1264001D9
	for <lists+kvm@lfdr.de>; Fri,  3 Sep 2021 17:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348122AbhICPSW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Sep 2021 11:18:22 -0400
Received: from mail-dm6nam12on2081.outbound.protection.outlook.com ([40.107.243.81]:7719
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229789AbhICPSV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Sep 2021 11:18:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=knxWae1TPFT1r3VEYAY7uk+ZQ0KXdAeK6zY6aj4hWVJ1sgBbNMTFFtU4Z08ytV7Gf3Gj9ql4XVPxni11XhJXVeZmljkR9EDvqCiiJIz5OV8ycBORXIzuau1pOwiVubCPG+ZVlDVqAdzx/irssu5yxkPU4cJbLqBaa3VoltK0X2IAWDrpUSlgxp980g/0hn8ZGTkFgfRajQWKOYJYKJCX33NpXM+/j+/En/tMheOW/5UsoEiYn7BoPzj+fzYMo7OcayHJNG64P3j8L1lXS9z9VjM6Xg9EunxSm4E6LBvy+OPbuYwazFDqvrBz/Q5O7BUrqM9WXNCUSipSp7F3T61jow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=HQfUrplaeahXn0O7YTO38jAioC9hmqeV37XKzdsp8hE=;
 b=W+rIi2C5sB0VsczLVacE0txbrkF6TdQr5RTqqOJf9eXCRpAdbVd5pwslYEdXmBDBv44q6+hvLE6Iiqg0Wi15WurrrdPQ5P2NKfRTxVtyQG3zXZIHZKvYOX/xraYBS/ITYo+l/34T8BAvYBIHwF6YgEvinA1kzVW3xbay+VVIfKT88K8gz0/lyv0u3XVWX4sSXsbE7jPO3EMlJIatcWurWDSmABTk/u3YrAwI3Q8Lul8GYIpgR3is7wNLsg1lmpnVptdxZwBUbcvwejuXU1DiGVx7skIZtAofOO3i2/s93yt5pYtpFmg1LvZFaEeQMj36w8GrJgl+RwyHhT65ayTtZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HQfUrplaeahXn0O7YTO38jAioC9hmqeV37XKzdsp8hE=;
 b=Jv8xx/1L4RgncZQlj0XLFEsBksuVqNF3X5QfeT2yU+5/NNfKv4o9mUGLxNH0nhLofFmrbSqqos6TnIbxdqHoxUnhELeKU5Sa5QeajBk884nKeFPK2v6w1XlM46w1MNBYw/S8YWxx6Ur+8fjvHF9bu4ryQtXIJogcM280JPIx7tI=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from CH2PR12MB4133.namprd12.prod.outlook.com (2603:10b6:610:7a::13)
 by CH2PR12MB4200.namprd12.prod.outlook.com (2603:10b6:610:ac::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.17; Fri, 3 Sep
 2021 15:17:19 +0000
Received: from CH2PR12MB4133.namprd12.prod.outlook.com
 ([fe80::f5af:373a:5a75:c353]) by CH2PR12MB4133.namprd12.prod.outlook.com
 ([fe80::f5af:373a:5a75:c353%6]) with mapi id 15.20.4478.022; Fri, 3 Sep 2021
 15:17:19 +0000
Date:   Fri, 3 Sep 2021 10:13:16 -0500
From:   Michael Roth <michael.roth@amd.com>
To:     Markus Armbruster <armbru@redhat.com>
Cc:     Tom Lendacky <thomas.lendacky@amd.com>,
        Daniel P =?utf-8?B?LiBCZXJyYW5nw6k=?= <berrange@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Connor Kuehl <ckuehl@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>, qemu-devel@nongnu.org,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [RFC PATCH v2 12/12] i386/sev: update query-sev QAPI format to
 handle SEV-SNP
Message-ID: <20210903151316.zveiegbo42o2gttq@amd.com>
References: <20210826222627.3556-1-michael.roth@amd.com>
 <20210826222627.3556-13-michael.roth@amd.com>
 <87tuj4qt71.fsf@dusky.pond.sub.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87tuj4qt71.fsf@dusky.pond.sub.org>
X-ClientProxiedBy: BN0PR02CA0001.namprd02.prod.outlook.com
 (2603:10b6:408:e4::6) To CH2PR12MB4133.namprd12.prod.outlook.com
 (2603:10b6:610:7a::13)
MIME-Version: 1.0
Received: from localhost (165.204.84.11) by BN0PR02CA0001.namprd02.prod.outlook.com (2603:10b6:408:e4::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19 via Frontend Transport; Fri, 3 Sep 2021 15:17:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 03ecf11f-54a9-45f9-7e39-08d96eedeb84
X-MS-TrafficTypeDiagnostic: CH2PR12MB4200:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CH2PR12MB4200CCACD28772C10244681E95CF9@CH2PR12MB4200.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4BE4lTepW1W8vAYGxlur9gW6Hz7cUQddSVF52aXL2oKdw0mbc8lIAv7Yee1jRQlJfKn6gUM5Xm8ixA6K6Pv9BSY2+5Gt2MU0C9N0SY4K4FAfuE+iF82JaOQAPITe5ukFQFMdap1E5D+51EColQLBxfPT8alBMERz3YfXF1+zmOzOppguLxEcrxrEKLBwWM7YNnMZ2SrgXY9ikx242BbHJ6OpCW1u+9wbdnS4el2wVtFLxbFfTiFAkloFIzAQfJCyUvbgzPbHIyhJHAtnqS90jEglZhX/eJtlcWsYrbhPO8wLenet+5BMygObYF9oFUsUqARMms8ndEgVGYmDx7bEmjUawvHE5fzSSl1B92k35ghG6SRTG1NPap1Ik1fF4hGgZqxVelOG/GEThD/d1cnbnGG/5aKmkAzm6l1+V0GK7p/JR0F7KIL8gv5LKLjNnqrP+MN3dlOSQIojlf+5pO2NUM9rrviiy50j+3HvKTnixzKQXIRp9yC9Kh77s6oTnoxkgKG47m5qcTjYNoV9rwSwNf8PwzJhBYqrL8Z6bEoavDdJ6Vldrmmv4dRD8tsyzA5g/HIHAIfWHOCPcEDiBF0Nhb96m8/uhv1X7xkiGHTAw9iX4O7kh2CkaNhsykSa0D0XFvDzYOWNavDRk9225uB/j1lK3ykWhrkT3N5zLb2RyBe/TxgTjm3tWx2FTbtXtewB+5GrDawnvX7B5hBS01CONg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB4133.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(396003)(346002)(366004)(136003)(83380400001)(26005)(54906003)(15650500001)(6916009)(7416002)(1076003)(4326008)(6486002)(186003)(66556008)(8936002)(66946007)(36756003)(66476007)(44832011)(956004)(2616005)(316002)(5660300002)(2906002)(52116002)(478600001)(38100700002)(38350700002)(6496006)(86362001)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6ZgUcD2HReC+NCaMEJ1nl7QxEMkA3cK0NtTecpgTEpvoWxRAPRo0f8bggRnE?=
 =?us-ascii?Q?6NRbTbNQb1sXTL1R9q5vW9vNgepdVV3kZ1ucW/rlI9mtJqbnyXoUTYzLKLqG?=
 =?us-ascii?Q?WcCzBZ4yheAF7CNok1ig2cx/Xhrgt9Z3GlciK+v7Kolf49zBu5JwK2EEDFzQ?=
 =?us-ascii?Q?/H0gda8/MBvei7tfCNfTdR8UMxh0oG+BNMGw4YIqi6mzB2/dZFnoA4lmS52K?=
 =?us-ascii?Q?NgG4gQZn+F89rXJwhWexHcTIgr8ZNjfT1IOaQl+MM7HiALoIPSvTTgdiD03R?=
 =?us-ascii?Q?FKGtgTxHmJ+AdeR+17PxbFQgf0sE2A4Qzb+J+w60dZy76aUawJFwraYHHzr1?=
 =?us-ascii?Q?r05PNvCZt4zV+FZKNS19Tcyayfqbo8N/mR/N5jr9e5l49D9qmNT4k3/C3z4F?=
 =?us-ascii?Q?PEJHYkAbE7C34F3otiOi451cMorCxgkzs4MrW4bBdp2jJ4/k189xY7i3+yyo?=
 =?us-ascii?Q?sQui23z6g/QC7eff1MGHa0JxsB4YIIs88RDz7uGEgWDOdtvU4y/1YQNryqEW?=
 =?us-ascii?Q?Vn0ppJaISaWK7FcEX3eIUz5K4Zd1TAOpCbeB81OvfDsOgjxblD//1GAx/IUU?=
 =?us-ascii?Q?OodWSqij4R7uvc7n9VoBH8J9A2ecrChQR/oUvM0aeV7piT9yY2NY5l0P7isT?=
 =?us-ascii?Q?SLzoEQ3HurOHCmJ0ZNpG7kJLSRjHT0tgrNH1tm0/QoZepeYqjZgMmUbLyOeK?=
 =?us-ascii?Q?j8p52Zcm6jyATMXfkh2tbIEJ/wwOGFo+N8Nwa2ZCgq3SNGKpzslAvPIPqqiH?=
 =?us-ascii?Q?+dM1ZW7H6uj7aDUXvuplPhDot9J7TE04uaCMvq/cpoQpByxsqWGYc8Wo9dQb?=
 =?us-ascii?Q?L1TPFs0EQszj00xX01NR0ZLBH0KAmmvSYe14xpZfC2tE5LFul20hbMEZEsLt?=
 =?us-ascii?Q?Ul6Ni8nen69FlJoVJte05EzNWSdNCWq0Or0VkNfD4NAgACucpbwtVHCNgGfQ?=
 =?us-ascii?Q?BtN0vgeKHDeYgGUBWfPU4Y7CZCLf9bcUoQmOA8iruI9rabnqW5YZxjkwPGFs?=
 =?us-ascii?Q?9VpVNbotFN89fut6y3mteIVh1R/a4fZCuHErIpIhCMVv2E4jlyMbWWx/0Otv?=
 =?us-ascii?Q?YKfA2F8xb4Bc5C2RmlloUgJpmSeO7WE+AS1+YyW0VnhkDx+t/6CHT7hHFQy/?=
 =?us-ascii?Q?SZ1NBrF7kxgmFO22v6vtfpf59F/g61yKyOl7ohI3mv93XPaio5yICOYXM1sJ?=
 =?us-ascii?Q?zcc51TUi7ueV3lDxbiKgs2e+QO87dVj5RzMCKI2yaGB2z7tSmpMSrpWMwsoK?=
 =?us-ascii?Q?fznlhB6oLWy3qaMYc+7/ypv1gIlEBC4zVhY+Qf+rUsweYWHGD+EgMZp6l9wu?=
 =?us-ascii?Q?T42lU0XkUeImdYo0JDwfs+YC?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03ecf11f-54a9-45f9-7e39-08d96eedeb84
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4133.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2021 15:17:18.9618
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GhUB3ogpJSqUnKQ4M9oie2tFxRLZ2cg7JUXalPR1C8IFXEehZ71kyhS3ZUuGIkBD54/O1BJs9XIPt22Mu3TlLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4200
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 01, 2021 at 04:14:10PM +0200, Markus Armbruster wrote:
> Michael Roth <michael.roth@amd.com> writes:
> 
> > Most of the current 'query-sev' command is relevant to both legacy
> > SEV/SEV-ES guests and SEV-SNP guests, with 2 exceptions:
> >
> >   - 'policy' is a 64-bit field for SEV-SNP, not 32-bit, and
> >     the meaning of the bit positions has changed
> >   - 'handle' is not relevant to SEV-SNP
> >
> > To address this, this patch adds a new 'sev-type' field that can be
> > used as a discriminator to select between SEV and SEV-SNP-specific
> > fields/formats without breaking compatibility for existing management
> > tools (so long as management tools that add support for launching
> > SEV-SNP guest update their handling of query-sev appropriately).
> 
> Technically a compatibility break: query-sev can now return an object
> that whose member @policy has different meaning, and also lacks @handle.
> 
> Matrix:
> 
>                             Old mgmt app    New mgmt app
>     Old QEMU, SEV/SEV-ES       good            good(1)
>     New QEMU, SEV/SEV-ES       good(2)         good
>     New QEMU, SEV-SNP           bad(3)         good
> 
> Notes:
> 
> (1) As long as the management application can cope with absent member
> @sev-type.
> 
> (2) As long as the management application ignores unknown member
> @sev-type.
> 
> (3) Management application may choke on missing member @handle, or
> worse, misinterpret member @policy.  Can only happen when something
> other than the management application created the SEV-SNP guest (or the
> user somehow made the management application create one even though it
> doesn't know how, say with CLI option passthrough, but that's always
> fragile, and I wouldn't worry about it here).
> 
> I think (1) and (2) are reasonable.  (3) is an issue for management
> applications that support attaching to existing guests.  Thoughts?

Hmm... yah I hadn't considering 'old mgmt' trying to interact with a SNP
guest started through some other means.

Don't really see an alternative other than introducing a new
'query-sev-snp', but that would still leave 'old mgmt' broken, since
it might still call do weird stuff like try to interpret the SNP policy
as an SEV/SEV-ES and end up with some very unexpected results. So if I
did go this route, I would need to have QMP begin returning an error if
query-sev is run against an SNP guest. But currently for non-SEV guests
it already does:

  error_setg(errp, "SEV feature is not available")

so 'old mgmt' should be able to handle the error just fine.

Would that approach be reasonable?
