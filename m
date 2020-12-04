Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B41C2CF2C5
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 18:13:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388387AbgLDRKD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Dec 2020 12:10:03 -0500
Received: from mail-dm6nam11on2082.outbound.protection.outlook.com ([40.107.223.82]:18849
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387823AbgLDRKC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Dec 2020 12:10:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EJK7qWmTbrdYsb0yRscOv+3k0cZRZYPIPtZ27WLDyDb3NqRDgfX3oEABPktkQa464s29qlQuJEzAodef2oPqgsXDjgTc28xQTSob5fNW1o5wvCOqWBxlMuR8u10pOzWkfoNs5IVj7sK2xI5PWNmYMOX/+G6z/SQuuC7VRgI0H6HjUJk9SvDy/mvaX86yOd0v2OBmAgb7Ufwa1mzZ0IPAZD7Mzm0iuE5pJvfYZl+QDW2T10tV6/Aik1nD4nGdOJ0xkucFcKH7VnnWoN+epxhvcv5sd7ea5mqoI/F0sojhrgbCwi9Ed3mMfJ126hCRcQxCQK5AnCtbZ+y6ROGR33u3tQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OhfkNWgdjI/cyZl1Sf5Fx3EII9OHr5jLqr5m7ZIy2ww=;
 b=QRj1amW1dAPr8qO1wMiNv/YtJkzXcWs3UfyYII8Od9/8qZiOkSZAxySlTpMUBmdNZiCSjU5kA7oEH9JIjXcq/1YxEK9cjfyw6WjLXp+yuBLiVVLTnFApdPz8fZBbh5Tu9A/c6wFyDWjHAPTED3Ur7X0XXBvqvCO332coowRyhe6nccH5V9j4IxNssRvCRsQy15nH6NhAzTStAoBJFlZutrOkjHuA6SpqRU9hwInHwahRgpmeaVb9RI7CM6IdiemXLM/VVeis7E//hM34NbK6THHIZFjvzfHbnvyZxMJgRbgBkY/HNFe5eE5WgPUlSLe7fUTUZK6lbPYvQZlE477/YA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OhfkNWgdjI/cyZl1Sf5Fx3EII9OHr5jLqr5m7ZIy2ww=;
 b=srHoVGksSGZ/cBETHCWekF9B0xZ0IUvR2gnoWVcAH4R5HByCU1lF/NPrcRwPnstYo5nTG16yQ61LYDmj1LhOPsxs1psphBRqZRjmlRGYx6mrXnZncOHKbA5Zq8rzDBynpDlkwMVM3xrCZaJqBOiUaOc+m97HFxaMajkDWRjKu2k=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4575.namprd12.prod.outlook.com (2603:10b6:806:73::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17; Fri, 4 Dec
 2020 17:09:10 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec%3]) with mapi id 15.20.3611.025; Fri, 4 Dec 2020
 17:09:10 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     seanjc@google.com
Cc:     Ashish.Kalra@amd.com, Thomas.Lendacky@amd.com, bp@suse.de,
        brijesh.singh@amd.com, hpa@zytor.com, joro@8bytes.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, pbonzini@redhat.com, rientjes@google.com,
        srutherford@google.com, tglx@linutronix.de,
        venu.busireddy@oracle.com, x86@kernel.org
Subject: Re: [PATCH v8 13/18] KVM: x86: Introduce new KVM_FEATURE_SEV_LIVE_MIGRATION feature & Custom MSR.
Date:   Fri,  4 Dec 2020 17:08:55 +0000
Message-Id: <20201204170855.1131-1-Ashish.Kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <X8pocPZzn6C5rtSC@google.com>
References: <X8pocPZzn6C5rtSC@google.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: DM5PR18CA0052.namprd18.prod.outlook.com
 (2603:10b6:3:22::14) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by DM5PR18CA0052.namprd18.prod.outlook.com (2603:10b6:3:22::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Fri, 4 Dec 2020 17:09:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b759dadf-64d6-427b-0c38-08d898775076
X-MS-TrafficTypeDiagnostic: SA0PR12MB4575:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4575ADE499EDEBD01BB9D7838EF10@SA0PR12MB4575.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +ZC1POlbDAAAQY8gHHQbGTyGleD4TTMR7GBBY/2hCzqx6B/4eM62UT4QkFnjlOIYz4Dba/9fO0hbf+xHI8azw8SktLGNtZHT2DtdhUrlqfv2lEsr97MRUY6SBxNZSNEDVl9s2rf5lxkknra3E7eEZQVDMbKi/uMPWFtGy7PYOSz+D/vKnNUVASugaw9bxH775fhziY5Iy7GXutadgYDNq0iQPNS0pVjxI7WFHbbAdxhjUVjMV3g+sna1XiDm4Io7RhjpeMzWBnIJ9GVycafWm9q1CfBOe81gEn0kEwFq/5cm4+r7mrKQGcyS9p55z64/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(346002)(39860400002)(396003)(366004)(16526019)(8676002)(26005)(8936002)(5660300002)(6916009)(2906002)(956004)(1076003)(7696005)(7416002)(52116002)(86362001)(4744005)(186003)(66476007)(2616005)(66556008)(4326008)(6486002)(66946007)(36756003)(478600001)(316002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?hUwHIiYjHto3KptjT7woxrRGPcX19FuXhE2dznJjBup7eoPO21LT6uBPD3rT?=
 =?us-ascii?Q?Dgh4gi+FoWvKGBPtJzlQl84x6xXcaFhh7bDnmFU7xEVfTT/l+DNSt9kuoP/e?=
 =?us-ascii?Q?4HRYXqr/pirc857jv1Y2DZUGklo2giHohFXWT7OrWL+ENaVBlEj2ZC1aUR1D?=
 =?us-ascii?Q?J6HhMCLuSf8kah8gREK7JKc0P7SQ5G9YDUGd3Vl9HC/UNxDfS6651orqgDZ8?=
 =?us-ascii?Q?XJxpeElAXHt8fApUqyI5S7VGI/pXdEi/pBSLfqApW+NF5E1Dmavsxg8RXMcT?=
 =?us-ascii?Q?zD/dh4QyzGcQSiOYTmpfYd5/uVemFI7V/uETSBilRj9qf+TZOsZwnQE6sE0z?=
 =?us-ascii?Q?lD0utViMXMlJtlZ1Eh8+0FitBQ4b3TK7Tr0u8SZjYVf4cUqctimcLjzC32wu?=
 =?us-ascii?Q?yRqwXPngrLzkDJsypLqioISVIt5BzUOsTfk0jrIs7pFkQ5y0N+1w0zp76H/P?=
 =?us-ascii?Q?wN0hoVJ0HQ9arJx2m0kSHEbklQjg8WC1/a13izIBOkCOzWA7xFsJxTn66lYy?=
 =?us-ascii?Q?bEIz4RgRmPKqpfZrfccKKt58wKFNXRQKQy+6C5+huxVKobMMUvNRkDQh1H4z?=
 =?us-ascii?Q?QzJoUvtJrgQs9Y0R6rKAT9PbsyHmTdcFQSLJiMCopYpOcbM6bdQyQQNxvOK8?=
 =?us-ascii?Q?t3pyabgeSiW6gDLvRf9C3AAuOaYlCaadvaUnlp6IiGv+6p0RI6a5xAQR4d3A?=
 =?us-ascii?Q?YcWzhT0faiLnQMmtAvjoVFNKBwzlpbbiRyhDffZ+BbJ+P9M1EfayZCN7mm0N?=
 =?us-ascii?Q?Q6uvtFUPMm2Yj3CVn6Bi/bc390D423YkE9bCXZ/hJYB/sNFg5Q/I8srYw8zr?=
 =?us-ascii?Q?JLeaRAlwnIim8kGtoaKWw9gwIEVvbcnOtMyQKr6WirhpLvvDE83OIxiNDsVb?=
 =?us-ascii?Q?zMGObGbZlpQ+EODKloxx+ayVAbTqj/SDrbBq3I0GDaMj1hwnzm+SwW+WmS1F?=
 =?us-ascii?Q?nVjEdMtU9sKBuMG3ILAw+ihz7OLCDbCDRBycbJJYQ+t77ouEROo8VRzDWRmC?=
 =?us-ascii?Q?r3U1?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b759dadf-64d6-427b-0c38-08d898775076
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2020 17:09:09.9444
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9OWFWvvt1SzYKLL8MhDSpH6krvb+9wHBClFVK+5RiYKTuzFM6AFrqmfIqudmk199XmI4gPqemzVsoyeKNONuIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4575
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

An immediate response, actually the SEV live migration patches are preferred over the Page encryption bitmap
patches, in other words, if SEV live migration patches are applied then we don't need the Page encryption bitmap
patches and we prefer the live migration series to be applied.

It is not that page encryption bitmap series supersede the live migration patches, they are just cut of the
live migration patches. 

Thanks,
Ashish
