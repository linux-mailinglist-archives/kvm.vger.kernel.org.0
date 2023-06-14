Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD56D72FDD9
	for <lists+kvm@lfdr.de>; Wed, 14 Jun 2023 14:05:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244386AbjFNMF0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jun 2023 08:05:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244279AbjFNMFY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jun 2023 08:05:24 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2060.outbound.protection.outlook.com [40.107.20.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 148E11FD8
        for <kvm@vger.kernel.org>; Wed, 14 Jun 2023 05:05:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=by933ks/kR8PGy8GrFVpXM6VemjxjYISVJsO30hUz8w=;
 b=gAg/BGA+l95ZMF2xhfwbQrmxYoBJAEzETrn7+d26rbsKgskCeTMEM+Rh0nZH6le3+STZsrGIbhWv5CIV+NOm6Mg4LU0JChkJcUiVcBIZNvCzd8J08uq6TTcoSaXD+SS3+bjKo/ZUq9gC0X57khzl7ywnKxNMOzoNsCB81yIrAJ4=
Received: from AM0PR10CA0039.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:150::19)
 by DU2PR08MB10302.eurprd08.prod.outlook.com (2603:10a6:10:46e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.44; Wed, 14 Jun
 2023 12:05:18 +0000
Received: from AM7EUR03FT035.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:20b:150:cafe::46) by AM0PR10CA0039.outlook.office365.com
 (2603:10a6:20b:150::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.36 via Frontend
 Transport; Wed, 14 Jun 2023 12:05:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM7EUR03FT035.mail.protection.outlook.com (100.127.141.24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6500.25 via Frontend Transport; Wed, 14 Jun 2023 12:05:18 +0000
Received: ("Tessian outbound 3570909035da:v136"); Wed, 14 Jun 2023 12:05:18 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 7011087508e78935
X-CR-MTA-TID: 64aa7808
Received: from 356180b194ff.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id E4C8BFB1-D1EF-4EE8-8A5D-761D510F2289.1;
        Wed, 14 Jun 2023 12:05:11 +0000
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 356180b194ff.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Wed, 14 Jun 2023 12:05:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CfIDkqhSI2OLw/3Xao7ePs1uPuRh/z0kpFgX5xWLwzIVIbuzbY7fq2lwQQKQyjzoBTkdokanWDs3ijC/n211Zm0zWV/NypHLZqpahOE8YhBAFIrHEcRE9468/vIPcIfIuwVdRhmjULMVRlJAAwjLnxn3D1WyvYGmphRt42nB2X9UmAhq8RE1IjY1849OFTaBPZpl3T6Q27lnWFT+r5l+1bh7QjGz+zmFEjokhrWn4+U9Ud8B6rXuseNVJY0Y7eWlWy774eYgabAzUEIbV8yizGtrhOj67vKgJB0Q+iqAtyjk31ZNfqm5UJcGfjBwICYykqDKGCVDM6JWYHl+OV9I1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=by933ks/kR8PGy8GrFVpXM6VemjxjYISVJsO30hUz8w=;
 b=gHkr8TymoQqMBvBHgXaem0l4JDhbksyC6S8/vw7jPkEv82MWPEByt8Kjy4pQQmxUZAox3RUYw6MVvkxqENdAHEc4xqgSvulQywwRMl/6vF4UUSRORt4LlePcyow6rvaQx9uDs1fr8AaEw5O67Uk1UUhejcUW4LM7iiDY4/iOy9au5YY6TqMJ4kQfTvMFuvyz4iktdAtAxpbOdaoEOD/ciU4Y+mtv2TL5wOjQmUkUyXawSDTv1+GsWUNXV99NCRCm0XP7Z7TkodglWEh2YKbw2UzJzZBu7Ag6oQZQ+dykEmFG2kXY2pKi+MovdUt/ro4jJ0menywOPBshpPPEE4e2OQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 40.67.248.234) smtp.rcpttodomain=linux.dev smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=by933ks/kR8PGy8GrFVpXM6VemjxjYISVJsO30hUz8w=;
 b=gAg/BGA+l95ZMF2xhfwbQrmxYoBJAEzETrn7+d26rbsKgskCeTMEM+Rh0nZH6le3+STZsrGIbhWv5CIV+NOm6Mg4LU0JChkJcUiVcBIZNvCzd8J08uq6TTcoSaXD+SS3+bjKo/ZUq9gC0X57khzl7ywnKxNMOzoNsCB81yIrAJ4=
Received: from DB8PR06CA0037.eurprd06.prod.outlook.com (2603:10a6:10:120::11)
 by GV1PR08MB8500.eurprd08.prod.outlook.com (2603:10a6:150:84::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.46; Wed, 14 Jun
 2023 12:05:06 +0000
Received: from DBAEUR03FT022.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:10:120:cafe::6e) by DB8PR06CA0037.outlook.office365.com
 (2603:10a6:10:120::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.36 via Frontend
 Transport; Wed, 14 Jun 2023 12:05:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 40.67.248.234)
 smtp.mailfrom=arm.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 40.67.248.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=40.67.248.234; helo=nebula.arm.com; pr=C
Received: from nebula.arm.com (40.67.248.234) by
 DBAEUR03FT022.mail.protection.outlook.com (100.127.142.217) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6500.23 via Frontend Transport; Wed, 14 Jun 2023 12:05:05 +0000
Received: from AZ-NEU-EX02.Emea.Arm.com (10.251.26.5) by AZ-NEU-EX03.Arm.com
 (10.251.24.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Wed, 14 Jun
 2023 12:05:05 +0000
Received: from AZ-NEU-EX03.Arm.com (10.251.24.31) by AZ-NEU-EX02.Emea.Arm.com
 (10.251.26.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Wed, 14 Jun
 2023 12:05:04 +0000
Received: from e124191.cambridge.arm.com (10.1.197.45) by mail.arm.com
 (10.251.24.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23 via Frontend
 Transport; Wed, 14 Jun 2023 12:05:04 +0000
Date:   Wed, 14 Jun 2023 13:05:03 +0100
From:   Joey Gouly <joey.gouly@arm.com>
To:     Oliver Upton <oliver.upton@linux.dev>
CC:     <kvmarm@lists.linux.dev>, <kvm@vger.kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        "Salil Mehta" <salil.mehta@huawei.com>, <nd@arm.com>
Subject: Re: [PATCH kvmtool 00/21] arm64: Handle PSCI calls in userspace
Message-ID: <20230614120503.GA3015626@e124191.cambridge.arm.com>
References: <20230526221712.317287-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230526221712.317287-1-oliver.upton@linux.dev>
X-EOPAttributedMessage: 1
X-MS-TrafficTypeDiagnostic: DBAEUR03FT022:EE_|GV1PR08MB8500:EE_|AM7EUR03FT035:EE_|DU2PR08MB10302:EE_
X-MS-Office365-Filtering-Correlation-Id: bfceaf33-078d-43ff-0dd9-08db6ccf9f38
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: iyVr4GvumxsvLOlatx1MHG39vjIn1rPp+o2hrETyNOh2jjpEEumJpTZXNVN4XUYrBgfWTuUHah62lm0pfm2PyLh7Jksbtw1lriRRBarvl1piW0nxi/Ya5tqhIpr8kCCp2kIDoMta0pGNK72MgYPWJ5S1Xh8+dGgGnRxji3ujs1DE1sF9GYEUrUNaKaFZU6RRHXvZOYRbTvtM4gOr3GlYFJJTEry3E37pbaL7LSkz4X7vViOVNz52Fh9G8ZLlOgXM5MsZ58R2Pl5kSTZ1VIaHcowFsEFfTdYMhW30bya6pG2KyYZy8ZDlOOmsnrZ7AJMgPVFPvDwxorT1sCIFfaTq7/TEOf21hEj+HNc4aPmmhOSUT5Mfb/5ona//fxtcmdq4oRPgZtZDHvBed33SHrEug9fFHjXCsiOSqA3iKGqahz2d7EO7kH54mSl1AT8z2sPJgY195SlLKT61qddKIK2DMu3uFxPBKAYdkAAWKGcjSRmfy0l7tpIfLRZ2NMueFcAUDZVjBuTp39ig2mdPvQ9MdJg6OyYCNZ7mlBa1zEIqcMeNe6p6i1/H44ZNH6xFvBQEGFJP9fdHSPScFiTjds4bZKytPdgaeI682pzonroJwQ0uRNrfgNxkiEgN8u7XfCJTrRDTHtn4Dt9ycS5pjxaUqv/ho75ILwoAVmohptAnwxuYe1qUqw3kpiQPtLbGFSCVHM7lOvyohEcw1UZfzUUG1VIMLTN5O3fBDEKJzBO50t+0W3ImNWh+/Qdt7m0R6mUTJ/GxFwjppTe8tKxwczwaqg==
X-Forefront-Antispam-Report-Untrusted: CIP:40.67.248.234;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:nebula.arm.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(136003)(39860400002)(396003)(451199021)(36840700001)(40470700004)(46966006)(82740400003)(40460700003)(478600001)(7696005)(36860700001)(47076005)(83380400001)(26005)(186003)(336012)(426003)(1076003)(33656002)(86362001)(82310400005)(356005)(81166007)(40480700001)(55016003)(6916009)(4326008)(70586007)(70206006)(316002)(8936002)(44832011)(5660300002)(41300700001)(2906002)(54906003)(8676002)(36900700001);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB8500
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM7EUR03FT035.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: 228019bd-1e84-40cd-f283-08db6ccf978e
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ksN4lsyTaAvTvsMi1Rc/KTxM20j/7z9oUIe/kaKkCN3YTABOIq+Nf9B8vfVcdRy+tYVz2LWnuPgvi+uaJkiP+IVdb/DchxrNZ/37v0gpxm8ebSNyBB1Bq8EJMvmV7RV8zA39BATbez6UBEVHESSZ/KRFoz37CZWmjZloMoUgXoDasSN2yppYti486cPERv0m/55LSVlM2CEwqV07/U6ws79JXfnaxIKkTcDbVpZmoW1Im/elb2gqMIEY6ZC2jYpMQM37kqCmQ311Fzg/pdm9XFkEPhBUh4ZLJqwr7gE0LzP9iFvXk57BL0oK7YAq9HUMO0e0iUTchBhsgf0FsrQcxpNOt6S86p4AKUnNUXhOLSHFR/9/aHwSbCDRAsFRXpWEQWjLGxDDjSss79qT0E/eeSlZ+vAq2guJtZqzjfn1vpfKJlc02UVHDi4tQ5a2w8gd3MtGR/s3sF+J3Jm2bbgblz5sijJjAmhDvZnli9q/WTlrDfxOFuN+gdiy/SW55v16uF3/UtA7or6+6ZNMm2Xk8gWEj4jg5E8ay1at1PzBfp3qz2CT1PXZX3pAhSbzkcyluycMPnkM8W9++pcN2We1nCCzM5Rj0lYLNmDdrX1JlP0Xs8y0o4ishdHLeH8nqCk9929r+jbzT6rlMAOPFguh8J3kFQxNhgHx4vuDPreFwbXcQejrqz6zCOfpbHljp22pYM4UA+rZ2AukUoKlaGyEOimiOm2XFzQeyqd/69/DTc1BBEqhxR48ONKfSRk/lBK0
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(346002)(39860400002)(376002)(451199021)(46966006)(36840700001)(40470700004)(5660300002)(8936002)(6862004)(8676002)(2906002)(70206006)(70586007)(44832011)(54906003)(7696005)(4326008)(1076003)(26005)(186003)(316002)(41300700001)(36860700001)(82740400003)(336012)(426003)(83380400001)(47076005)(40460700003)(478600001)(33656002)(40480700001)(55016003)(86362001)(82310400005)(81166007);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 12:05:18.7713
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bfceaf33-078d-43ff-0dd9-08db6ccf9f38
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: AM7EUR03FT035.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR08MB10302
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Oliver,

On Fri, May 26, 2023 at 10:16:51PM +0000, Oliver Upton wrote:
> The 6.4 kernel picks up support for a generalized SMCCC filter, allowing
> userspace to select hypercall ranges that should be forwarded to
> userspace. This is a shameless attempt of making future SMCCC interfaces
> the responsibility of userspace :)
> 
> As a starting point, let's move PSCI up into userspace. KVM already
> leans on userspace for handling calls that have a system-wide effect.
> 
> Tested on linux-next with a 64 vCPU VM. Additionally, I took a stab at
> running kvm-unit-test's psci test, which passes.

I applied these patches to kvmtool and tested 6.4, however they don't work
with an SVE enabled kernel/device.

# ./lkvm run -c 2 -m 4 -k psci.flat                                                                                                                                                
INFO: psci: PSCI version 1.0                                                                                                                                                         
PASS: psci: invalid-function                                                                                                                                                         
PASS: psci: affinity-info-on                                                                                                                                                         
PASS: psci: affinity-info-off                                                                                                                                                        
  Error: KVM_ARM_VCPU_FINALIZE: Operation not permitted                                                                                                                              
  Fatal: Unable to configure requested vcpu features 

`kvm_cpu__configure_features` in kvmtool is failing because Linux returns an
error if SVE was already finalised (arch/arm64/kvm/reset.c):

```
int kvm_arm_vcpu_finalize(struct kvm_vcpu *vcpu, int feature)
{
        switch (feature) {
        case KVM_ARM_VCPU_SVE:
                if (!vcpu_has_sve(vcpu))
                        return -EINVAL;

                if (kvm_arm_vcpu_sve_finalized(vcpu))
                        return -EPERM; // <---- returns here

                return kvm_vcpu_finalize_sve(vcpu);
        }

        return -EINVAL;
}
```

It's not immediately obvious to me why finalising SVE twice is an error.
Changing that to `return 0;` gets the test passing, but not sure if there
are other implications.

I also booted with `arm64.nosve` and the test passed.

Thanks,
Joey
