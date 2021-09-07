Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E8C3402D15
	for <lists+kvm@lfdr.de>; Tue,  7 Sep 2021 18:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344956AbhIGQsg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Sep 2021 12:48:36 -0400
Received: from mail-bn1nam07on2056.outbound.protection.outlook.com ([40.107.212.56]:31367
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1344952AbhIGQsf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Sep 2021 12:48:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dtK9uobB9Jc4Edwd7bg26CWkN/3K8SI27pQ7TiUUmsgWg0yssV1CEYMUo3b60Chgblae122aJ2Zse+99vlms9S7uvvY0Ab5JdoWFowgPhDrcS383ZWE6EXoVoGVFeHI5lFC+MtspYSf8kVjzvN5G4ENJx2PyM2rPrIwFlTGgvaWlGfIRPegwR46F2nBXUDKjwA42P4zzw7zlNpfptKpK74i1l5qqF3Bl939ZX8dzsZmHSyFymyTttZbsrc0br9RCv0bOG/f6vx5FeLcJmunoEuSvAl97kYsT4NnqHQVUts3xQPk9UXkr1GAfk51I65GYqX0wXGp+mUjwm6nuEJ+7rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=PXW5egNX/tctNdArAI5iXwQ9Jqc0My7GtyBQSOW7fyk=;
 b=jk5O5DHTJ3dIyMu4NUTkl+zWg7J/+jw/L6RmIKOq50gnMibnV4hBwzgvMGa4ToY/ycjgjBjVRQPf6jKYEd8ufiFrjL2hvyqLnpp1gv3QaiB7TwBzb2D4osH/gXP4rLMYSUPt6VBn22ioSY/xAf/i1Bv8ltBxnX5/WMxi0xfO1/uFpeUQ3f9Kcs/izk2wo/wG1Apo2Z5ORrqrXI2lmzpfN3tYuSC6c9R9wdSU9/A5f4FcjTP+taoTa7cNMPBjloDmIxmMQAYCeQuDGgDDwlP3k+yw3W6EGpwnCWQG6iaeK87ZjO1BxFcni435B+7/63QEGeULrS91Hg0MioEPZyHhOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PXW5egNX/tctNdArAI5iXwQ9Jqc0My7GtyBQSOW7fyk=;
 b=QviG9xKClLE9MPxTP76Sdt28/qgZrKIIu2zNwA2fFhJRiBARvrMpZuhS9FvpZxfBCAlFfb69dhnPDf1bGEv9sAH+YAz7l6uj1i0/I5uxdh4Kb3PtwrJfrZCRfYIUZfcBg6bp5HLLGIOg1TV+AVgRDzo3gKMYMjDUADLZtS3UVQ0=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from CH2PR12MB4133.namprd12.prod.outlook.com (2603:10b6:610:7a::13)
 by CH2PR12MB3704.namprd12.prod.outlook.com (2603:10b6:610:21::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.22; Tue, 7 Sep
 2021 16:47:25 +0000
Received: from CH2PR12MB4133.namprd12.prod.outlook.com
 ([fe80::f5af:373a:5a75:c353]) by CH2PR12MB4133.namprd12.prod.outlook.com
 ([fe80::f5af:373a:5a75:c353%6]) with mapi id 15.20.4478.025; Tue, 7 Sep 2021
 16:47:25 +0000
Date:   Tue, 7 Sep 2021 09:33:51 -0500
From:   Michael Roth <michael.roth@amd.com>
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc:     Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>,
        Markus Armbruster <armbru@redhat.com>, qemu-devel@nongnu.org,
        Connor Kuehl <ckuehl@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        kvm@vger.kernel.org, Eduardo Habkost <ehabkost@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Eric Blake <eblake@redhat.com>
Subject: Re: [RFC PATCH v2 12/12] i386/sev: update query-sev QAPI format to
 handle SEV-SNP
Message-ID: <20210907143351.t67w7w4cwhrxy4ws@amd.com>
References: <20210826222627.3556-1-michael.roth@amd.com>
 <20210826222627.3556-13-michael.roth@amd.com>
 <87tuj4qt71.fsf@dusky.pond.sub.org>
 <YTJGzrnqO9vzUqNq@redhat.com>
 <YTdSlg5NymDQex5T@work-vm>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YTdSlg5NymDQex5T@work-vm>
X-ClientProxiedBy: SN2PR01CA0070.prod.exchangelabs.com (2603:10b6:800::38) To
 CH2PR12MB4133.namprd12.prod.outlook.com (2603:10b6:610:7a::13)
MIME-Version: 1.0
Received: from localhost (76.251.165.188) by SN2PR01CA0070.prod.exchangelabs.com (2603:10b6:800::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Tue, 7 Sep 2021 16:47:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 569b30ab-1a95-4454-8738-08d9721f2bda
X-MS-TrafficTypeDiagnostic: CH2PR12MB3704:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CH2PR12MB3704E4C089CF5A004C98BFCD95D39@CH2PR12MB3704.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jmGXYsYr9tVug5VWDcXoq50Q68JixYMGGLw/lKI/zNrKUG0tvFOZ+dvBTB1rKelc6tmyp6r/qLAjQ7kmMVhSWO9qEo9LptV8j/BRYrQpKLI+yhCMIMPlLhxg+vtF56VHbAx4MvsU7MZT5uWvm4kIaui9qlooC0q/cB8PEm2Asm8xAYTYM9ET40nAm8lwHvHkLRIsEve+AHQvX/KNqGzBS8FqBhTMI/l7zm576YSOAGW7VajaVfBVvjmZ4DHf2b/3/DUgu+GwaW5ucuakjHD4ytQR2snuB55Im/zk9mJ/2BNrgMtEaaOa224vh/k2IXUrkKvQrz8Mes3XDcCC6us982YBJt4dm3yOW+mZZzpFqKXIL9sPzYUj5TgsFDRG/8wSi+KHnYikIbadepPexb/C1lT3uaV/xbLZkKX/IBugLbBYfNPqH5HxCTLLQu61AagahF7WENyYsOFdbx3IQ11PkggoNDyX06zB+KrEH0oIo8XRLk4rcewBo+lM2dRtovVRl2rhXQjGkwH7olN/NI7JoTMuOfTQ11kc7P7dEstHm79wFsLX9ZGDdhi9/N6U2tPzdXpMatVVdXQ5x5RJED9CZPxymjqqEmOdGdwKyilwAn9cBGTNghN+SlllEqagb49dG8wD/wM6SVDJ/vUePTFvviUkX+9CYjlKWmLjIHEuy5iK1WUiVzDRTYnUHp7cC1/gGAlc4H/TZBIHelIxBatiYqsY13uKjNl7PsFFB05iVYjFQbOHhuTSj3zJQdyecV8P1SZ34DsQVj6dhWFyaPAoDz4OcYwK5v7o6rAjwpzY4vLewl4b/WuqVv5IXZqPDR25oGafuVi1hliRdjbPmQp0vA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB4133.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6666004)(7416002)(508600001)(86362001)(186003)(44832011)(6496006)(956004)(26005)(5660300002)(83380400001)(66556008)(36756003)(45080400002)(2616005)(6486002)(6916009)(38100700002)(38350700002)(8676002)(66946007)(54906003)(66476007)(2906002)(316002)(52116002)(1076003)(966005)(4326008)(15650500001)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?ccgC6uQlPILBnqpUdTxwTZhXZdWCxrUSWwWhYHKMDzfqJZhdOEYK0pCh3u?=
 =?iso-8859-1?Q?ZeJDdC2xwPz8cvP0FRGqzb852jZyP2YLfuatz6ooFgLnv3m5gpqOm6cFP/?=
 =?iso-8859-1?Q?I2JywjkC0SNU5llcqHu+2USzLAX59StuP5Mc/RFTQmGhCfcozidUN49yqP?=
 =?iso-8859-1?Q?T1SFaZ4neslavGXaemYfjQbuCYhWrFZsaOcGGcprgw9McdjO3PU1qAmjeJ?=
 =?iso-8859-1?Q?At0opWatktvtK2Hd51ZiVR91MxfYihk8c7/zNc4KaVU64g9XYN2/JXftF6?=
 =?iso-8859-1?Q?YZoVXSiaMkarJAgUytGta3tIGVbJpt6lk1I8VW6vk03I8gIFI/knQKx5Un?=
 =?iso-8859-1?Q?Fm4XII4Bj9A1bckU2yGBeOhO434s1iCWDL/H7YTN69XLFBMajwW8BIj3wT?=
 =?iso-8859-1?Q?CDLVadKk3JdbHLpYnvoK5HISL7gr+g7f/xyscb+gIJgxl3jd7xiL1RdGz9?=
 =?iso-8859-1?Q?bs267Fydf6GTul3DhFTXR1qiwcXXGRF6e/SqCxuLtXQ8KFYDvNf1AtDt9g?=
 =?iso-8859-1?Q?eP3tIlGTz5boMiD9NG3OgdUTe5xz5ffzgRcXAuU9yRoyZ0DsrxxV96+adc?=
 =?iso-8859-1?Q?KhZyF8M6yabIR979WsoXBwYxQ0B/uZaa2VZMYSYMsS2/ukeuYGRLk2lnE3?=
 =?iso-8859-1?Q?gITVPGE3e4UUisdqSOIpzqJFXoBNUNMZ++ttZPAz7Cz+fZ1AiFgH/+2Etg?=
 =?iso-8859-1?Q?G5g6qEpdv6CZJ2pr9evg9iMamrtTa8QJR/XohID3noBv9GA9yQr16xrXqA?=
 =?iso-8859-1?Q?fFefVa6oXMEbFO8US6bkNoIeeSZkNBCG6tWAzUeX69MtgH0nn5q8woU36s?=
 =?iso-8859-1?Q?GkijIhmz/WtoHEwcK6VtMHUhr4DUki5DrZyWa0VLcPoqHnRkjvpgW2sFwU?=
 =?iso-8859-1?Q?Tu6dscLs/kLajQ6FOz+v1lRZl52XrMCexOHSFgbOuSegyeYh99CwKU/n9y?=
 =?iso-8859-1?Q?wg2cIvwAknaMfvQx3sF4P6yBzkjBU2LdkcsyeZrtek1Fo8y+Ic1lkSvkCE?=
 =?iso-8859-1?Q?4pV+t9qvIY2xLxSrwdzM6NnmUXqZw6eLkLHVsBt+f8dtIO3d4Hy9k4kYjL?=
 =?iso-8859-1?Q?8UCLbLz/z/dMj/Tms3G/nR+Y/1Cg9pheJgrVi3CMd675zHk5YYiRwlZoIF?=
 =?iso-8859-1?Q?nPz3g8CLquEjKfTTIbfjmUzV6p9rMzLYA6nFpc1ECYI3o4YZmVlgs8orZv?=
 =?iso-8859-1?Q?/8SoOXqaOvRAnJWlcHNtZW+A5PZgRGLsvGhD8hrAFne8rSWweaXkhxi8qN?=
 =?iso-8859-1?Q?uI0bftk5zu/ZDJT7+wgsQ7u5exoOumBKVrT5aBL+EY8bRMFETPad+vyX5h?=
 =?iso-8859-1?Q?Q6ZRR5CwoLsnmCJImV4pI2UOGdwqXG/0W1E6fvo/NOly+XsM6Dxkr60cQ2?=
 =?iso-8859-1?Q?wEiU2Dc8bb?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 569b30ab-1a95-4454-8738-08d9721f2bda
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4133.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2021 16:47:25.6851
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xak3BlwXxmqvxuT3sSuQ6aS07BagOfE8vtcECbKtby3VkUlj5tO4m17IhgTb/2+XuX+2IJ/Tl1Lm/Fpnlds4BA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3704
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 07, 2021 at 12:52:54PM +0100, Dr. David Alan Gilbert wrote:
> * Daniel P. Berrangé (berrange@redhat.com) wrote:
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
> > IIUC you can only reach scenario (3) if you have created a guest
> > using '-object sev-snp-guest', which is a new feature introduced
> > in patch 2.
> > 
> > IOW, scenario (3)  old mgmt app + new QEMU + sev-snp guest does
> > not exist as a combination. Thus the (bad) field is actually (n/a)
> > 
> > So I believe this proposed change is acceptable in all scenarios
> > with existing deployed usage, as well as all newly introduced
> > scenarios.
> 
> I wonder if it's worth going firther and renaming 'policy' in the 
> SNP world to 'snppolicy' just to reduce the risk of accidentally
> specifying the wrong one.

Seems reasonable. I'll plan on renaming to 'snp-policy' if there are no
objections.

> 
> Dave
> 
> > Regards,
> > Daniel
> > -- 
> > |: https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fberrange.com%2F&amp;data=04%7C01%7Cmichael.roth%40amd.com%7Cb9a484cd5d4f484b542908d971f61073%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637666123947391605%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=D56oHIuVk%2FmAJaKYtpJ3ZEZpKZpDPWZXydV3tpYjcM4%3D&amp;reserved=0      -o-    https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fwww.flickr.com%2Fphotos%2Fdberrange&amp;data=04%7C01%7Cmichael.roth%40amd.com%7Cb9a484cd5d4f484b542908d971f61073%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637666123947401567%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=A9YA65nj6En3f3E2wm%2BVZE%2F6DpdbDKyHSWN9VXHAk8U%3D&amp;reserved=0 :|
> > |: https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flibvirt.org%2F&amp;data=04%7C01%7Cmichael.roth%40amd.com%7Cb9a484cd5d4f484b542908d971f61073%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637666123947401567%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=yf%2FV3f3%2FNxEDwmYESp7D0ZOn74aM6cXskVJrvHLvXRE%3D&amp;reserved=0         -o-            https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Ffstop138.berrange.com%2F&amp;data=04%7C01%7Cmichael.roth%40amd.com%7Cb9a484cd5d4f484b542908d971f61073%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637666123947401567%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=pUYNVu6WWgPtwjwrjvz3YCCY7S1Qli%2FfvQKmkaRu3gc%3D&amp;reserved=0 :|
> > |: https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fentangle-photo.org%2F&amp;data=04%7C01%7Cmichael.roth%40amd.com%7Cb9a484cd5d4f484b542908d971f61073%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637666123947401567%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=opdXI%2BlyzxWhUbNNgka6sMKMiLmMHfk8WuZY6cMy7yE%3D&amp;reserved=0    -o-    https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fwww.instagram.com%2Fdberrange&amp;data=04%7C01%7Cmichael.roth%40amd.com%7Cb9a484cd5d4f484b542908d971f61073%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637666123947401567%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=8cV6tsleO5nDBVKR3WX74a%2BKch5RdRdmPciv%2F6T9nOg%3D&amp;reserved=0 :|
> > 
> -- 
> Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
> 
