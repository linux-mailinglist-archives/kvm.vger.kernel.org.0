Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC4D1400280
	for <lists+kvm@lfdr.de>; Fri,  3 Sep 2021 17:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349661AbhICPop (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Sep 2021 11:44:45 -0400
Received: from mail-bn7nam10on2065.outbound.protection.outlook.com ([40.107.92.65]:46272
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1349574AbhICPoo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Sep 2021 11:44:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FwYUB08xunrssV+q0nlzZfttHR8/AKHZaVMZY7vuUtyh7TG8/MFPCXATH18KXKHONiPPA7wsNH9StvjphWeV41A8po659WMQfCnyyFc7053Zsa9C6Qtrkuqkb0dgr6CUphAAfntnf/8h/7Bl5Ar1opB/BiWsrwRcZp0eRiY621ljqtOpM1Dj1UE7O/Zlq7TeZRt0xdXvpjEfl8bCgyC7vdTfIYWckwDftqcoSR/G7Px0bSQLg++UEBR3rcT+KJ5zvNQp4K7uXeFV66SMTdeXSWySHHrHE8NNAELyxidAy7jfX1HHuFuC9gg8mVzMfEO5EZZZJODfQTqXDpfAYwtYIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=qgwmsSBYOi17mTQw5pZ8pwL7X9Fb82yn+4yI9Ct83QM=;
 b=eiTJtJN5355Mw7n2U1htCzZP5j+A88ezjogUwRtit3qh/wGLngFkyJUsdKcRdmuS3DUg7/RTTpPdnyPaFmO6M+AlozAJbXgK8I67wet1ecSk/Ppfk5ipgW3Gh3f/J59LDJXpEci9W4qVQbXR1f/i6SoX0CiM9hJ37qhBlpuoy34MvgNZ0lRvLdwoyIfdfYLDAqwM/pTINjt6U4tUgFyRAjTjyAWairPwX71F2IFywTozqFmoBH5sFEnJw+Rsj2+mEY12oxQ2lgKXQPOIG3cazLzwVXMtxVcuGVbTxLIF33tCQ4Z/TI2I6dlzC8vRSFlG23wQ2rgr1IrkcVknju6jQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qgwmsSBYOi17mTQw5pZ8pwL7X9Fb82yn+4yI9Ct83QM=;
 b=W43K/1i0fjBNxn7cetLpc3JgNuI5/PCUw2sFcMocxnmF6dly83pTXy8Y0V0JQTjZycRVs2cg6CSrdnvyq9JXtKkBaahCdVNGpgzW8Wujlao4Kkk1PAMTl1bv0SIqhfS1Q0Hr1V7zIzYp6U9HXkHKWihIjarbQnGdgm0TR+2OE9k=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from CH2PR12MB4133.namprd12.prod.outlook.com (2603:10b6:610:7a::13)
 by CH2PR12MB3894.namprd12.prod.outlook.com (2603:10b6:610:2b::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19; Fri, 3 Sep
 2021 15:43:42 +0000
Received: from CH2PR12MB4133.namprd12.prod.outlook.com
 ([fe80::f5af:373a:5a75:c353]) by CH2PR12MB4133.namprd12.prod.outlook.com
 ([fe80::f5af:373a:5a75:c353%6]) with mapi id 15.20.4478.022; Fri, 3 Sep 2021
 15:43:42 +0000
Date:   Fri, 3 Sep 2021 10:43:19 -0500
From:   Michael Roth <michael.roth@amd.com>
To:     Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
Cc:     Markus Armbruster <armbru@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
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
Message-ID: <20210903154319.zxvgccxayjoabtck@amd.com>
References: <20210826222627.3556-1-michael.roth@amd.com>
 <20210826222627.3556-13-michael.roth@amd.com>
 <87tuj4qt71.fsf@dusky.pond.sub.org>
 <20210903151316.zveiegbo42o2gttq@amd.com>
 <YTI/qB4uk477/lQP@redhat.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YTI/qB4uk477/lQP@redhat.com>
X-ClientProxiedBy: BN6PR14CA0003.namprd14.prod.outlook.com
 (2603:10b6:404:79::13) To CH2PR12MB4133.namprd12.prod.outlook.com
 (2603:10b6:610:7a::13)
MIME-Version: 1.0
Received: from localhost (165.204.84.11) by BN6PR14CA0003.namprd14.prod.outlook.com (2603:10b6:404:79::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.20 via Frontend Transport; Fri, 3 Sep 2021 15:43:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 772b9d78-b827-4175-9c72-08d96ef19b5c
X-MS-TrafficTypeDiagnostic: CH2PR12MB3894:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CH2PR12MB389410B9E5A937E7696CBF3F95CF9@CH2PR12MB3894.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2F6sARmY4EmoI7q4TCX6ytNv2cebF3jWUHBnOAnKCJiemCfrVF14kD29W1lKUKpyoMBeTRcfWcakOGtHDLYuPB9kzB9iVVwfr/U36aJpowrXkAYWUVXX1j7EgxoKBxr8ok6cPbRNTVbTjuDSHk2xQkhg/St7yUaxP3J7mHX0NVB2t0Xll1RPn0H22aI1beG4ZXK1j45NEjoF1ZiqshEKI+tqPkx/ucyOvys+MHbsBsM2OwC9VTNM2dIHHw+CtvjbuWyf+CMOB9/yn85ejhI9qEK5MGeCcr0ES5zqTtavry+C9NI0F0R9aZciW5P+w8DlXf6QR1G5mdpz3xCTC8KKuR+sHYnAm8aeM84R0dWpuvRbybD2cNOWHkPWiNk4+DilCas4ACmDR6sQ10G44C8qDChkej1rjUfXF9/EEuZ+jRQeJAmjlT3XQfzWFVK98Q2MmewEma30bCe1N3DDWYbb4Q8ixrZsWFcBzd8aWce2XK1OC0/e6yk3OA9Ny1yYviW6KndxHTfabfLzJteuFzxcxbOR3MgKBw3qvD+90DoHbCeR5QANX9Gwjt5vB6Z4X06KGP79iuWOm7H/tF/s12V4EyPCJdcTay2ahZjny7lyGaozLJfrdnmlNzeFqIVDfUPvSsE8uTx5tHuHaX4TDaKfHdx/CZBVSzPcaF91CKrdYUlg52PWG3ZHpedHPimniAY9K+4ZYfleVo3RAbEXA7DorFJC4JscSv/NXxSEkBlU/XUf7yvA/5SlYDgnPL99ni9B1Gv6wCaM7iMkpegW8lqpVA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB4133.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(376002)(346002)(136003)(396003)(44832011)(6666004)(6916009)(4326008)(5660300002)(7416002)(52116002)(2616005)(15650500001)(8936002)(8676002)(54906003)(66556008)(66476007)(66946007)(6486002)(86362001)(316002)(36756003)(45080400002)(2906002)(38350700002)(38100700002)(6496006)(478600001)(956004)(83380400001)(186003)(26005)(1076003)(966005)(3716004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?Vo1Iqccy9wsfLxYiQapFn8R4U/CWyi2Ibbi6pXVKa3e+1qjSC0exaotCyT?=
 =?iso-8859-1?Q?cYRFo2noWTP2mkZaZdwajc10qq/3PChDRAo8ZLFEYEMjSIrIIi69tdc8ak?=
 =?iso-8859-1?Q?/Fn76252Xzq/RxUMiqM5P/f1GCHPYBVXcWbKM1ztQHvb+/1u7uzkymEwP9?=
 =?iso-8859-1?Q?Qs4r/0g3cRXrlYHiJ7J7peANf9WBbS0O6OhVIhWjDp5BhXs1vXj09mOoGn?=
 =?iso-8859-1?Q?11s0iIIriMdEe7jZ3d6LQknofkn3/c0DRGAhb2pXsnu4ioefwrF1CUKSwd?=
 =?iso-8859-1?Q?8ByKpTkp+ZbU3vBpjxuTRxboB5pf/pkrNH+B0DzhDK4q+8f06nPgtcoGHa?=
 =?iso-8859-1?Q?ASAao167EEMU3UViRXBpFaJWdi57P77uDaN66XT38fWDgRbJMN/DXxe66M?=
 =?iso-8859-1?Q?N7ykpyAc+OrMUlqBCIGq1wC7d2EunHVIoUWiQOAtljTwuRa9NyeGcRigoy?=
 =?iso-8859-1?Q?q1p2RoA0pbrdm8Xup6FPcBhLnCj5423+eBSYVBjrCYSegIG/tNhILhHbyK?=
 =?iso-8859-1?Q?CgPps/SoMzcqH1Cd3V7ML7q4vTzrtOS75fMW8WUB7HBpDuRz7xzNOcrpSi?=
 =?iso-8859-1?Q?rSGXRQnJF1b97fLPbEWUuspzLh76ar+rZ/+SfJWutanncS9Dp/6bJMGmzJ?=
 =?iso-8859-1?Q?H6qICiXOxgK/Ul0AZNkZrBIvSEKDSRA4aYlMxM2MeRby2rjfxiYJcyOqeo?=
 =?iso-8859-1?Q?U1f4xFI6z95Z52lKiH77IkvuaIzkrtzjmSF6Hvui6vCnyOcfQ34o888/g7?=
 =?iso-8859-1?Q?IiuSRZNhBsvflkyh+TXi+i/aULf+RldqmxEdTpKpqKenAygtWbgNikGHUb?=
 =?iso-8859-1?Q?LhD8nEFD/t9ko+yq3Tc9OuX9wBnFsnpSt9zcxghDhFKwIx47Iinn8SqvhZ?=
 =?iso-8859-1?Q?vO4IyCJytZ7V4MRwZH/Ffg+2k82isMth627UtuFXb5Ialy+NpBLeVJVvhb?=
 =?iso-8859-1?Q?P/KoyxZvpWCuxXC2prO0R3s+79in5N7aO829mE8acv5bX53d1L1TXhmi+X?=
 =?iso-8859-1?Q?bQul7+udqUoG9QsmgMxLKM//0+yg8dPVN/7aXzhfMNH9wV3IXi66LdWSrU?=
 =?iso-8859-1?Q?Y+OUWDN1zgXZxSZ0OifX7NuCCsmRBk9oYQoD/gs3Iap8LBfmjtW41AJ/ps?=
 =?iso-8859-1?Q?0OnpVjJl9dAWkQsnk5UWtAZHZ1FVLVusbiuW2qlhLLZ/Ez5yIwzRlUaKQG?=
 =?iso-8859-1?Q?oyLuxAXB+z5nLWlWnBn44GxnRGTIH8Qml90eVD3OaY3BHKBz3nSYeC8CxJ?=
 =?iso-8859-1?Q?rdMptvVA0tF77MFa08U1gqtaClZH/9Efw0I9zJp+3eNVwwQuNN9QFpI3hS?=
 =?iso-8859-1?Q?M6PzlE50Ptv7tNbuzBmSPza8THoKVrggRczndEd+Z4pfKcYAMFtcufn56g?=
 =?iso-8859-1?Q?NqcfLm6ePR?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 772b9d78-b827-4175-9c72-08d96ef19b5c
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4133.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2021 15:43:42.3830
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 16I8ERi6H3iAJILvPBuPQGWbooWayYYRrjZUG9/9ePqqOZJoU1K09ky6yK3mDZc59OQV4/c4/HprEhfgzqrzRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3894
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 03, 2021 at 04:30:48PM +0100, Daniel P. Berrangé wrote:
> On Fri, Sep 03, 2021 at 10:13:16AM -0500, Michael Roth wrote:
> > On Wed, Sep 01, 2021 at 04:14:10PM +0200, Markus Armbruster wrote:
> > > Michael Roth <michael.roth@amd.com> writes:
> > > 
> > > > Most of the current 'query-sev' command is relevant to both legacy
> > > > SEV/SEV-ES guests and SEV-SNP guests, with 2 exceptions:
> > > >
> > > >   - 'policy' is a 64-bit field for SEV-SNP, not 32-bit, and
> > > >     the meaning of the bit positions has changed
> > > >   - 'handle' is not relevant to SEV-SNP
> > > >
> > > > To address this, this patch adds a new 'sev-type' field that can be
> > > > used as a discriminator to select between SEV and SEV-SNP-specific
> > > > fields/formats without breaking compatibility for existing management
> > > > tools (so long as management tools that add support for launching
> > > > SEV-SNP guest update their handling of query-sev appropriately).
> > > 
> > > Technically a compatibility break: query-sev can now return an object
> > > that whose member @policy has different meaning, and also lacks @handle.
> > > 
> > > Matrix:
> > > 
> > >                             Old mgmt app    New mgmt app
> > >     Old QEMU, SEV/SEV-ES       good            good(1)
> > >     New QEMU, SEV/SEV-ES       good(2)         good
> > >     New QEMU, SEV-SNP           bad(3)         good
> > > 
> > > Notes:
> > > 
> > > (1) As long as the management application can cope with absent member
> > > @sev-type.
> > > 
> > > (2) As long as the management application ignores unknown member
> > > @sev-type.
> > > 
> > > (3) Management application may choke on missing member @handle, or
> > > worse, misinterpret member @policy.  Can only happen when something
> > > other than the management application created the SEV-SNP guest (or the
> > > user somehow made the management application create one even though it
> > > doesn't know how, say with CLI option passthrough, but that's always
> > > fragile, and I wouldn't worry about it here).
> > > 
> > > I think (1) and (2) are reasonable.  (3) is an issue for management
> > > applications that support attaching to existing guests.  Thoughts?
> > 
> > Hmm... yah I hadn't considering 'old mgmt' trying to interact with a SNP
> > guest started through some other means.
> > 
> > Don't really see an alternative other than introducing a new
> > 'query-sev-snp', but that would still leave 'old mgmt' broken, since
> > it might still call do weird stuff like try to interpret the SNP policy
> > as an SEV/SEV-ES and end up with some very unexpected results. So if I
> > did go this route, I would need to have QMP begin returning an error if
> > query-sev is run against an SNP guest. But currently for non-SEV guests
> > it already does:
> > 
> >   error_setg(errp, "SEV feature is not available")
> > 
> > so 'old mgmt' should be able to handle the error just fine.
> > 
> > Would that approach be reasonable?
> 
> This ties into the question I've just sent in my other mail.
> 
> If the hardware strictly requires that guest are created in SEV-SNP
> mode only, and will not support SEV/SEV-ES mode, then we need to
> ensure "query-sev" reports the feature as not-available, so that
> existing mgmt apps don't try to use SEV/SEV-ES.

An SEV-SNP-capable host can run both 'legacy' SEV/SEV-ES, as well as
SEV-SNP guests, at the same time. But as far as QEMU goes, we need
to specify one or the other explicitly at launch time, via existing
'sev-guest', or the new 'sev-snp-guest' ConfidentialGuestSupport type.

> 
> If the SEV-SNP hardware is functionally back-compatible with a gues
> configured in SEV/SEV-ES mode, then we souldn't need a new command,
> just augment th eexisting command with additional field(s), to
> indicate existance of SEV-SNP features.

query-sev-info provides information specific to the guest instance,
like the configured policy. Are you thinking of query-sev-capabilities,
which reports some host-wide information and should indeed remain
available for either case. (and maybe should also be updated to report
on SEV-SNP availability for the host?)

> 
> Regards,
> Daniel
> -- 
> |: https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fberrange.com%2F&amp;data=04%7C01%7Cmichael.roth%40amd.com%7C86e4ceb7f55f4cf839e708d96eefd768%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637662798671249591%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=Fo%2FCcCEG7OrpVNj2ij2CzYJCMFXs30YUnRaClz17Okc%3D&amp;reserved=0      -o-    https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fwww.flickr.com%2Fphotos%2Fdberrange&amp;data=04%7C01%7Cmichael.roth%40amd.com%7C86e4ceb7f55f4cf839e708d96eefd768%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637662798671249591%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=ypMyoiFFTmgWnDD3UwJrKIcHGzDaKQ8nXnFASw7gyRE%3D&amp;reserved=0 :|
> |: https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flibvirt.org%2F&amp;data=04%7C01%7Cmichael.roth%40amd.com%7C86e4ceb7f55f4cf839e708d96eefd768%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637662798671249591%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=viWBuUPauLi41pEKT143wh0Ds%2FwJqIG%2BDfraIO5uxNE%3D&amp;reserved=0         -o-            https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Ffstop138.berrange.com%2F&amp;data=04%7C01%7Cmichael.roth%40amd.com%7C86e4ceb7f55f4cf839e708d96eefd768%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637662798671249591%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=H%2BTFPox5kDO4osMWicvwUrb8PvNfMBPLwCWEiEfcIOw%3D&amp;reserved=0 :|
> |: https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fentangle-photo.org%2F&amp;data=04%7C01%7Cmichael.roth%40amd.com%7C86e4ceb7f55f4cf839e708d96eefd768%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637662798671259556%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=9mp0c7dJ07EIdYYNZ73DQ6ax%2Bw0ORKTpScI6p5gNpVo%3D&amp;reserved=0    -o-    https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fwww.instagram.com%2Fdberrange&amp;data=04%7C01%7Cmichael.roth%40amd.com%7C86e4ceb7f55f4cf839e708d96eefd768%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637662798671259556%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=%2FL1f9LxzAqXxVNbUhWa4w2Sibb6f0vLcRzaM2%2F9NY90%3D&amp;reserved=0 :|
> 
