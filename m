Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 971256A208C
	for <lists+kvm@lfdr.de>; Fri, 24 Feb 2023 18:39:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229503AbjBXRjn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 12:39:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjBXRjm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 12:39:42 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2048.outbound.protection.outlook.com [40.107.6.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72C6C12BF9
        for <kvm@vger.kernel.org>; Fri, 24 Feb 2023 09:39:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y+Mquk+doNCSkQvjFUfh5rDFFyToCmATVjTfKjdboPg=;
 b=Mda3YbKSvbj+DXK5X0B5VghOQvkh/AsIf6Krile4cqGuT1iuQzsVwwQ7xpMAG8FAHZrh2fNqPaDXTXoUKVnDF7Q0zVgQ5PFasVcv6Ul+2tAyW6cpLAMdAmP4Lyz3O4Dc7+7oEIdg3YsSCfqjGJvfRV6Fbh6lwrtB/GyF+plmSn8=
Received: from AS8PR05CA0005.eurprd05.prod.outlook.com (2603:10a6:20b:311::10)
 by AS8PR08MB8370.eurprd08.prod.outlook.com (2603:10a6:20b:56b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.21; Fri, 24 Feb
 2023 17:39:32 +0000
Received: from AM7EUR03FT025.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:20b:311:cafe::d6) by AS8PR05CA0005.outlook.office365.com
 (2603:10a6:20b:311::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.24 via Frontend
 Transport; Fri, 24 Feb 2023 17:39:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM7EUR03FT025.mail.protection.outlook.com (100.127.140.199) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6134.24 via Frontend Transport; Fri, 24 Feb 2023 17:39:32 +0000
Received: ("Tessian outbound 8038f0863a52:v132"); Fri, 24 Feb 2023 17:39:31 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: a2e41d6173dd45b6
X-CR-MTA-TID: 64aa7808
Received: from 40227014cb69.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 859C19F4-A94C-463E-8B63-8C136ABAB569.1;
        Fri, 24 Feb 2023 17:39:25 +0000
Received: from EUR02-AM0-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 40227014cb69.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Fri, 24 Feb 2023 17:39:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HzlImGxW1VQt07b63wNd/+9eahFLjkbRjhXm5QeTfubTVuerKLkprAs7rlS9M3Bgzsq6mSixOUlkZOUQ0YwbBIZNee//JNnjeFxwzzQYIbK2zoySN9Qng2TOpFKF811CxGFHRJS3s+tNGy2YYO8PaYmHnSqWykw3VNE83SbKvlPqW0gVIYg5zgaVUXjk3cNfvbQE3G9vk0QZ4fgV/qkxI6ZaTzPz6tMD1GzKe0WA5KKR4mQM3VY8hhN3Zi5ZXTB5GIjTJdXomnSj9uxCvedcbGKiR6393kno8f7rbQ9wa/uKqQGAPIrwKC2B9TWwcXGxYF/gjn2K6KB//ZRlXldBzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y+Mquk+doNCSkQvjFUfh5rDFFyToCmATVjTfKjdboPg=;
 b=eUB5JHaqDk/2gLQBuO/iB3UPHk011OWcadReouEkWNhUwoqOMYGRI+6pgA+243z2eSFmLL5YTbsbhfBI2xgyEH0Ky7vpDChyw800OeG6S2yorMAU/eSonJ70dt64YmY4tb8dxC3RiePS2Vj4PBxizdVsbSV5oVkshJhpcCG1fyjkc3APFM3fyLl57LPercBh/YxVn9l5MIKdYm0jFOoIr+kgay/nwA8N45JV4DIRWGkQl3s9XcxVFRvLY+oJQtgcCcMmscQowGwS56RHvzOCYvgPa9F7Tf9vWc2qlbnBVnKNPD+ZNRjg9P4l9Rn+3HVdjZLY+vGDymqc5QbuQ8z94w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 40.67.248.234) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y+Mquk+doNCSkQvjFUfh5rDFFyToCmATVjTfKjdboPg=;
 b=Mda3YbKSvbj+DXK5X0B5VghOQvkh/AsIf6Krile4cqGuT1iuQzsVwwQ7xpMAG8FAHZrh2fNqPaDXTXoUKVnDF7Q0zVgQ5PFasVcv6Ul+2tAyW6cpLAMdAmP4Lyz3O4Dc7+7oEIdg3YsSCfqjGJvfRV6Fbh6lwrtB/GyF+plmSn8=
Received: from AS9PR06CA0278.eurprd06.prod.outlook.com (2603:10a6:20b:45a::18)
 by AS8PR08MB9576.eurprd08.prod.outlook.com (2603:10a6:20b:618::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.24; Fri, 24 Feb
 2023 17:39:18 +0000
Received: from AM7EUR03FT009.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:20b:45a:cafe::5f) by AS9PR06CA0278.outlook.office365.com
 (2603:10a6:20b:45a::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.24 via Frontend
 Transport; Fri, 24 Feb 2023 17:39:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 40.67.248.234)
 smtp.mailfrom=arm.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 40.67.248.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=40.67.248.234; helo=nebula.arm.com; pr=C
Received: from nebula.arm.com (40.67.248.234) by
 AM7EUR03FT009.mail.protection.outlook.com (100.127.140.130) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6156.11 via Frontend Transport; Fri, 24 Feb 2023 17:39:18 +0000
Received: from AZ-NEU-EX02.Emea.Arm.com (10.251.26.5) by AZ-NEU-EX04.Arm.com
 (10.251.24.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.17; Fri, 24 Feb
 2023 17:39:18 +0000
Received: from AZ-NEU-EX03.Arm.com (10.251.24.31) by AZ-NEU-EX02.Emea.Arm.com
 (10.251.26.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.17; Fri, 24 Feb
 2023 17:39:17 +0000
Received: from e124191.cambridge.arm.com (10.1.197.45) by mail.arm.com
 (10.251.24.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.17 via Frontend
 Transport; Fri, 24 Feb 2023 17:39:17 +0000
Date:   Fri, 24 Feb 2023 17:39:15 +0000
From:   Joey Gouly <joey.gouly@arm.com>
To:     Marc Zyngier <maz@kernel.org>
CC:     <kvmarm@lists.linux.dev>, <kvm@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        "Catalin Marinas" <catalin.marinas@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        "Suzuki K Poulose" <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>, <nd@arm.com>
Subject: Re: [PATCH 08/18] KVM: arm64: nv: Handle HCR_EL2.NV system register
 traps
Message-ID: <20230224173915.GA17407@e124191.cambridge.arm.com>
References: <20230209175820.1939006-1-maz@kernel.org>
 <20230209175820.1939006-9-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230209175820.1939006-9-maz@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EOPAttributedMessage: 1
X-MS-TrafficTypeDiagnostic: AM7EUR03FT009:EE_|AS8PR08MB9576:EE_|AM7EUR03FT025:EE_|AS8PR08MB8370:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b451d08-a24b-4b46-3d9b-08db168e1678
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: MBTeWccmd3p5w/CWwHbl6CYGiwhtxfi5NDkP6xgqnpC5Z53jbUjNeJDAlsmhd4RyVNdiFRL/rYPdf9MZbmbbodSh/tBPw8vAEV2YlCkFJdTUUdUt7Fqii/Ph9ganjuVcw7sc/qhsz0E1vYMRU2H95CZ527WXy1ymNkI/FKo8ARE0ehMWTZse9foZL8+WMm8IyVS6uXCd1YAjPVLZS8RTS1b4ZmhgG5BTMpzAw6d3ioMNUtEGQsWo3WkNqtdJGobeoYvFLiBp4pRKuXv348Wi8Cs4RvJP/cM+hYcW6iFx6knJdgCSoEUCGX7gpuHGiuR8wCDN74WQQeqgV9IMslH7NrReVzhgLpgetwZCNhvOxBIwAmjOidDxXlEGidiszlH1KLrkMeYLxkKMPik7YpsLyfr/IjeY+8vrqVv8Yb1FAro5u08Kf2vcqRqVegArAQ16TAG9JzxSoTDhNsRyKzMIYsCc4chIWdyuJJ0RL2/czs2UF9Taa/3xJlYh67p6uMxph5z5wUK03qfFT1h99mdwOJAScz/m9THaITt09IOqwxwecQOUulpsqn8qTnLSP7v6eCKoqSanXozGawmoy6W1HImBQUq8WqBz3SOzr1bIJkq8dpAN5rBkb+8Xq4300125TQbShCZmZjXkEZSqy6MUgrat9rnnW5VFlECCcotmSomTvdXMKBplwJimHunggJh3
X-Forefront-Antispam-Report-Untrusted: CIP:40.67.248.234;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:nebula.arm.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(39860400002)(136003)(346002)(451199018)(46966006)(36840700001)(82310400005)(82740400003)(30864003)(44832011)(86362001)(36860700001)(2906002)(81166007)(966005)(336012)(7696005)(426003)(26005)(47076005)(33656002)(186003)(55016003)(40480700001)(356005)(54906003)(83380400001)(41300700001)(70206006)(70586007)(4326008)(6916009)(1076003)(8936002)(8676002)(316002)(478600001)(5660300002)(36900700001);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB9576
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM7EUR03FT025.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: 9fbfe4fc-b544-414c-cd5e-08db168e0e75
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PnD+YA6DQasoizbvM4Ne0jmlLfnWGl1QpvlKd/2FrsAyxkMehM1frL7T6XZ5rwE+FjpayI6p3ab1wdISL3D4xmPxRlljVk0t9WxPfZ6NKYXiUsK346jZTjhylH3KUTmPWvoHhx8sV6bX0nc9NJvQFn0xN35MYJREG11bJ3BtGtI6ubNaq6v6bdVFlLt+igq/HGumen5REzquKJsLNcoduqyG1isz5xXhuD72EOYNCnNqn1eJWDTBWqq1JC4QqxOzMJ4N6iEFbybJlorjD8aQfvGFeM2qNnfjN6d1ayR/Yk5mf5PDa2hPwtO8N4SD801pSZRhnrCP5yCtjSirik5sA9gqQRC1U00hItufTLS9As/kVLp9uXqn192BWN5trIHAlnfju+b1umZJYqDo/m7TrEOUvJxEo455nQew1pgsRliMIZirSQewygjjXYWmw5PqXRCmaXnb8PFJZtBUbnP5pKBTkUWm3rB5zMZW1Yh0FrdJgLBu4xAaKyuq5hAE3HAiENUqPCpY2yZbJxOHLIYFKYA5vqlnLCJPasYKsLWBZo/KYiiEnKXsNMYvdJ0gps+KTNHgt+wpxbnTYmHa/FHCOhGGF7XparlCEV+xqFGBhgJkI4lv1//WCCXTeb+77Uxc9nQy0ZUlUfniAhQsYuVnSLWCx6kTrawW4wJ+yVfDIAyouKiD1h5x/M9n3bvwMeo2
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230025)(4636009)(136003)(39860400002)(346002)(396003)(376002)(451199018)(36840700001)(40470700004)(46966006)(33656002)(86362001)(2906002)(6862004)(8936002)(41300700001)(30864003)(44832011)(5660300002)(82740400003)(36860700001)(70206006)(4326008)(83380400001)(81166007)(7696005)(40480700001)(316002)(8676002)(70586007)(966005)(478600001)(26005)(40460700003)(186003)(82310400005)(54906003)(1076003)(55016003)(336012)(47076005)(426003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2023 17:39:32.0421
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b451d08-a24b-4b46-3d9b-08db168e1678
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: AM7EUR03FT025.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB8370
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        RCVD_IN_VALIDITY_RPBL,SPF_HELO_PASS,SPF_NONE,UNPARSEABLE_RELAY
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On Thu, Feb 09, 2023 at 05:58:10PM +0000, Marc Zyngier wrote:
> From: Jintack Lim <jintack.lim@linaro.org>
> 
> ARM v8.3 introduces a new bit in the HCR_EL2, which is the NV bit. When
> this bit is set, accessing EL2 registers in EL1 traps to EL2. In
> addition, executing the following instructions in EL1 will trap to EL2:
> tlbi, at, eret, and msr/mrs instructions to access SP_EL1. Most of the
> instructions that trap to EL2 with the NV bit were undef at EL1 prior to
> ARM v8.3. The only instruction that was not undef is eret.
> 
> This patch sets up a handler for EL2 registers and SP_EL1 register
> accesses at EL1. The host hypervisor keeps those register values in
> memory, and will emulate their behavior.
> 
> This patch doesn't set the NV bit yet. It will be set in a later patch
> once nested virtualization support is completed.
> 
> Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
> [maz: EL2_REG() macros]
> Signed-off-by: Marc Zyngier <maz@kernel.org>
[..]
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index c6cbfe6b854b..1e6ae3b2e6dd 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -24,6 +24,7 @@
>  #include <asm/kvm_emulate.h>
>  #include <asm/kvm_hyp.h>
>  #include <asm/kvm_mmu.h>
> +#include <asm/kvm_nested.h>
>  #include <asm/perf_event.h>
>  #include <asm/sysreg.h>
>  
> @@ -102,6 +103,18 @@ static u32 get_ccsidr(u32 csselr)
>  	return ccsidr;
>  }
>  
> +static bool access_rw(struct kvm_vcpu *vcpu,
> +		      struct sys_reg_params *p,
> +		      const struct sys_reg_desc *r)
> +{
> +	if (p->is_write)
> +		vcpu_write_sys_reg(vcpu, p->regval, r->reg);
> +	else
> +		p->regval = vcpu_read_sys_reg(vcpu, r->reg);
> +
> +	return true;
> +}
> +
>  /*
>   * See note at ARMv7 ARM B1.14.4 (TL;DR: S/W ops are not easily virtualized).
>   */
> @@ -260,6 +273,14 @@ static bool trap_raz_wi(struct kvm_vcpu *vcpu,
>  		return read_zero(vcpu, p);
>  }
>  
> +static bool trap_undef(struct kvm_vcpu *vcpu,
> +		       struct sys_reg_params *p,
> +		       const struct sys_reg_desc *r)
> +{
> +	kvm_inject_undefined(vcpu);
> +	return false;
> +}
> +
>  /*
>   * ARMv8.1 mandates at least a trivial LORegion implementation, where all the
>   * RW registers are RES0 (which we can implement as RAZ/WI). On an ARMv8.0
> @@ -370,12 +391,9 @@ static bool trap_debug_regs(struct kvm_vcpu *vcpu,
>  			    struct sys_reg_params *p,
>  			    const struct sys_reg_desc *r)
>  {
> -	if (p->is_write) {
> -		vcpu_write_sys_reg(vcpu, p->regval, r->reg);
> +	access_rw(vcpu, p, r);
> +	if (p->is_write)
>  		vcpu_set_flag(vcpu, DEBUG_DIRTY);
> -	} else {
> -		p->regval = vcpu_read_sys_reg(vcpu, r->reg);
> -	}
>  
>  	trace_trap_reg(__func__, r->reg, p->is_write, p->regval);
>  
> @@ -1446,6 +1464,24 @@ static unsigned int mte_visibility(const struct kvm_vcpu *vcpu,
>  	.visibility = mte_visibility,		\
>  }
>  
> +static unsigned int el2_visibility(const struct kvm_vcpu *vcpu,
> +				   const struct sys_reg_desc *rd)
> +{
> +	if (vcpu_has_nv(vcpu))
> +		return 0;
> +
> +	return REG_HIDDEN;
> +}
> +
> +#define EL2_REG(name, acc, rst, v) {		\
> +	SYS_DESC(SYS_##name),			\
> +	.access = acc,				\
> +	.reset = rst,				\
> +	.reg = name,				\
> +	.visibility = el2_visibility,		\
> +	.val = v,				\
> +}
> +
>  /* sys_reg_desc initialiser for known cpufeature ID registers */
>  #define ID_SANITISED(name) {			\
>  	SYS_DESC(SYS_##name),			\
> @@ -1490,6 +1526,18 @@ static unsigned int mte_visibility(const struct kvm_vcpu *vcpu,
>  	.visibility = raz_visibility,		\
>  }
>  
> +static bool access_sp_el1(struct kvm_vcpu *vcpu,
> +			  struct sys_reg_params *p,
> +			  const struct sys_reg_desc *r)
> +{
> +	if (p->is_write)
> +		__vcpu_sys_reg(vcpu, SP_EL1) = p->regval;
> +	else
> +		p->regval = __vcpu_sys_reg(vcpu, SP_EL1);
> +
> +	return true;
> +}
> +
>  /*
>   * Architected system registers.
>   * Important: Must be sorted ascending by Op0, Op1, CRn, CRm, Op2
> @@ -1913,9 +1961,50 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  	{ PMU_SYS_REG(SYS_PMCCFILTR_EL0), .access = access_pmu_evtyper,
>  	  .reset = reset_val, .reg = PMCCFILTR_EL0, .val = 0 },
>  
> +	EL2_REG(VPIDR_EL2, access_rw, reset_unknown, 0),
> +	EL2_REG(VMPIDR_EL2, access_rw, reset_unknown, 0),
> +	EL2_REG(SCTLR_EL2, access_rw, reset_val, SCTLR_EL2_RES1),
> +	EL2_REG(ACTLR_EL2, access_rw, reset_val, 0),
> +	EL2_REG(HCR_EL2, access_rw, reset_val, 0),
> +	EL2_REG(MDCR_EL2, access_rw, reset_val, 0),
> +	EL2_REG(CPTR_EL2, access_rw, reset_val, CPTR_EL2_DEFAULT ),
> +	EL2_REG(HSTR_EL2, access_rw, reset_val, 0),
> +	EL2_REG(HACR_EL2, access_rw, reset_val, 0),
> +
> +	EL2_REG(TTBR0_EL2, access_rw, reset_val, 0),
> +	EL2_REG(TTBR1_EL2, access_rw, reset_val, 0),
> +	EL2_REG(TCR_EL2, access_rw, reset_val, TCR_EL2_RES1),
> +	EL2_REG(VTTBR_EL2, access_rw, reset_val, 0),
> +	EL2_REG(VTCR_EL2, access_rw, reset_val, 0),
> +
>  	{ SYS_DESC(SYS_DACR32_EL2), NULL, reset_unknown, DACR32_EL2 },
> +	EL2_REG(SPSR_EL2, access_rw, reset_val, 0),
> +	EL2_REG(ELR_EL2, access_rw, reset_val, 0),
> +	{ SYS_DESC(SYS_SP_EL1), access_sp_el1},
> +
>  	{ SYS_DESC(SYS_IFSR32_EL2), NULL, reset_unknown, IFSR32_EL2 },
> +	EL2_REG(AFSR0_EL2, access_rw, reset_val, 0),
> +	EL2_REG(AFSR1_EL2, access_rw, reset_val, 0),
> +	EL2_REG(ESR_EL2, access_rw, reset_val, 0),
>  	{ SYS_DESC(SYS_FPEXC32_EL2), NULL, reset_val, FPEXC32_EL2, 0x700 },
> +
> +	EL2_REG(FAR_EL2, access_rw, reset_val, 0),
> +	EL2_REG(HPFAR_EL2, access_rw, reset_val, 0),
> +
> +	EL2_REG(MAIR_EL2, access_rw, reset_val, 0),
> +	EL2_REG(AMAIR_EL2, access_rw, reset_val, 0),
> +
> +	EL2_REG(VBAR_EL2, access_rw, reset_val, 0),
> +	EL2_REG(RVBAR_EL2, access_rw, reset_val, 0),
> +	{ SYS_DESC(SYS_RMR_EL2), trap_undef },
> +
> +	EL2_REG(CONTEXTIDR_EL2, access_rw, reset_val, 0),
> +	EL2_REG(TPIDR_EL2, access_rw, reset_val, 0),
> +
> +	EL2_REG(CNTVOFF_EL2, access_rw, reset_val, 0),
> +	EL2_REG(CNTHCTL_EL2, access_rw, reset_val, 0),
> +
> +	EL2_REG(SP_EL2, NULL, reset_unknown, 0),
>  };
>  
>  static bool trap_dbgdidr(struct kvm_vcpu *vcpu,
> -- 
> 2.34.1
> 
> 

I'm having an issue with this commit where a VCPU is getting a CNTVOFF_EL2 set
to 0, so it sees the same time as the host system, and the other VCPU has the
correct offset.

This is due to the new line added in this commit:

	EL2_REG(CNTVOFF_EL2, access_rw, reset_val, 0),

Here is an excerpt of the dmesg:

[    0.000000] Booting Linux on physical CPU 0x0000000000 [0x000f0510]                                                                                                               
[    0.000000] Linux version 5.14.0-rc1-00011-gc2b59ec4a322-dirty SMP PREEMPT
[    0.000000] Machine model: linux,dummy-virt                                                                                                                                       
[    0.000000] efi: UEFI not found.                                                                                                                                                  
[    0.000000] earlycon: ns16550a0 at MMIO 0x0000000001000000 (options '')                                                                                                           
[    0.000000] printk: bootconsole [ns16550a0] enabled                                                                                                                               
[    0.000000] NUMA: No NUMA configuration found                                                                                                                                     
[    0.000000] NUMA: Faking a node at [mem 0x0000000080000000-0x0000000093ffffff]                                                                                                    
[    0.000000] NUMA: NODE_DATA [mem 0x93f60c00-0x93f62fff]                                                                                                                           
[    0.000000] Zone ranges:                                                                                                                                                          
[    0.000000]   DMA      [mem 0x0000000080000000-0x0000000093ffffff]                                                                                                                
[    0.000000]   DMA32    empty                                                                                                                                                      
[    0.000000]   Normal   empty                                                                                                                                                      
[    0.000000] Movable zone start for each node                                                                                                                                      
[    0.000000] Early memory node ranges                                                                                                                                              
[    0.000000]   node   0: [mem 0x0000000080000000-0x0000000093ffffff]                                                                                                               
[    0.000000] Initmem setup node 0 [mem 0x0000000080000000-0x0000000093ffffff]                                                                                                      
[    0.000000] On node 0, zone DMA: 16384 pages in unavailable ranges                                                                                                                
[    0.000000] cma: Reserved 32 MiB at 0x0000000091800000                                                                                                                            
[    0.000000] psci: probing for conduit method from DT.                                                                                                                             
[    0.000000] psci: PSCIv1.1 detected in firmware.                                                                                                                                  
[    0.000000] psci: Using standard PSCI v0.2 function IDs                                                                                                                           
[    0.000000] psci: Trusted OS migration not required                                                                                                                               
[    0.000000] psci: SMC Calling Convention v1.1                                                                                                                                     
[    0.000000] smccc: KVM: hypervisor services detected (0x00000000 0x00000000 0x00000000 0x00000003)                                                                                
[    0.000000] percpu: Embedded 33 pages/cpu s96088 r8192 d30888 u135168                                                                                                             
[    0.000000] Detected PIPT I-cache on CPU0                                                                                                                                         
[    0.000000] CPU features: detected: Branch Target Identification                                                                                                                  
[    0.000000] CPU features: detected: GIC system register CPU interface                                                                                                             
[    0.000000] CPU features: detected: Spectre-v4                                                                                                                                    
[    0.000000] CPU features: kernel page table isolation forced ON by KASLR                                                                                                          
[    0.000000] CPU features: detected: Kernel page table isolation (KPTI)             
[..]
[    0.516017] fsl-mc MSI: msic domain created
[    0.544449] EFI services will not be available.
[    0.575385] smp: Bringing up secondary CPUs ...
[    0.658517] smp: Brought up 1 node, 2 CPUs
[    0.849724] SMP: Total of 2 processors activated.
[    0.893825] CPU features: detected: 32-bit EL0 Support
[    0.935321] CPU features: detected: 32-bit EL1 Support
[    0.989719] CPU features: detected: ARMv8.4 Translation Table Level
[    1.049576] CPU features: detected: Data cache clean to the PoU not required for I/D coherence
[    1.108269] CPU features: detected: Common not Private translations
[    1.151863] CPU features: detected: CRC32 instructions
[    1.186088] CPU features: detected: RCpc load-acquire (LDAPR)
[    1.225008] CPU features: detected: LSE atomic instructions
[    1.262173] CPU features: detected: Privileged Access Never
[    1.299687] CPU features: detected: RAS Extension Support
[    1.337388] CPU features: detected: Random Number Generator
[    1.374957] CPU features: detected: Speculation barrier (SB)
[    1.412860] CPU features: detected: Stage-2 Force Write-Back
[    1.458967] CPU features: detected: TLB range maintenance instructions
[    1.503504] CPU features: detected: Speculative Store Bypassing Safe (SSBS)
[    6.740431] CPU: All CPU(s) started at EL1
[    6.779526] alternatives: patching kernel code
[ 1685.522538] devtmpfs: initialized
[ 1685.591049] KASLR enabled
[ 1685.614942] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 7645041785100000 ns
[ 1685.686698] futex hash table entries: 512 (order: 3, 32768 bytes, linear)
[ 1685.748071] pinctrl core: initialized pinctrl subsystem
[ 1685.809348] DMI not present or invalid.
[ 1685.854306] NET: Registered PF_NETLINK/PF_ROUTE protocol family
[ 1685.924942] DMA: preallocated 128 KiB GFP_KERNEL pool for atomic allocations
[ 1685.981774] DMA: preallocated 128 KiB GFP_KERNEL|GFP_DMA pool for atomic allocations
[ 1686.042387] DMA: preallocated 128 KiB GFP_KERNEL|GFP_DMA32 pool for atomic allocations
[ 1686.099864] audit: initializing netlink subsys (disabled)
[ 1686.152647] audit: type=2000 audit(5.488:1): state=initialized audit_enabled=0 res=1
[    7.525335] thermal_sys: Registered thermal governor 'step_wise'
[    7.565113] thermal_sys: Registered thermal governor 'power_allocator'
[    7.609143] cpuidle: using governor menu
[    7.681526] NET: Registered PF_QIPCRTR protocol family
[    7.720877] hw-breakpoint: found 6 breakpoint and 4 watchpoint registers.
[    7.770844] ASID allocator initialised with 32768 entries
[    7.816662] Serial: AMBA PL011 UART driver
[ 1686.613910] HugeTLB registered 1.00 GiB page size, pre-allocated 0 pages
[ 1686.666303] HugeTLB registered 32.0 MiB page size, pre-allocated 0 pages
[ 1686.725358] HugeTLB registered 2.00 MiB page size, pre-allocated 0 pages
[ 1686.772979] HugeTLB registered 64.0 KiB page size, pre-allocated 0 pages
[..]

The flow of execution looks like this:
	KVM_CREATE_VCPU 0 (VMM) ->
		kvm_timer_vcpu_init ->
			update_vtimer_cntvoff (VCPU0.CNTVOFF_EL2=kvm_phys_timer_read)
	KVM_ARM_VCPU_INIT (VMM) ->
		kvm_arch_vcpu_ioctl_vcpu_init ->
			kvm_vcpu_set_target ->
				kvm_reset_vcpu ->
					kvm_reset_sys_regs (VCPU0.CNTVOFF_EL2=0)

	KVM_CREATE_VCPU 1 (VMM) ->
		kvm_timer_vcpu_init ->
			update_vtimer_cntvoff (VCPU0.CNTVOFF_EL2=VCPU1.CNTVOFF_EL2=kvm_phys_timer_read)
	KVM_ARM_VCPU_INIT (VMM) ->
		kvm_arch_vcpu_ioctl_vcpu_init ->
			kvm_vcpu_set_target ->
				kvm_reset_vcpu ->
					kvm_reset_sys_regs (VCPU1.CNTVOFF_EL2=0)

	At this point VCPU0 has CNTVOFF_EL2 == kvm_phys_timer_read, and VCPU1
	has CNTVOFF_EL2 == 0.

The VCPUs having different CNTVOFF_EL2 valuess is just a symptom of the fact that
CNTVOFF_EL2 is now reset in kvm_reset_sys_regs.

This is with linux kvmarm/next [1], kvmtool [2], qemu [3] (I also saw similar
behaviour on FVP).

qemu-system-aarch64 -M virt \                                                                                                                                        
      -machine virtualization=true \                                                                                                                                                 
      -machine virt,gic-version=3 \                                                                                                                                                 
      -machine mte=off \                                                                                                                                                             
      -cpu max,pauth=off -smp 2 -m 12144 \                                                                                                                         
      -drive if=none,format=qcow2,file=disk.img,id=blk0 \                                                                                                                  
      -device virtio-blk-pci,drive=blk0 \                                                                                                                                            
      -nographic \                                                                                                                                           
      -device virtio-net-pci,netdev=net0 \                                                                                                                            
      -netdev user,id=net0,hostfwd=tcp::8024-:22 \                                                                                                                        
      -kernel ../linux/arch/arm64/boot/Image \                                                                                                                                       
      -append "root=/dev/vda2" 

And then running kvmtool:
	lkvm run -k Image -p earlycon

Hopefully that is all that is needed to reproduce it.

The following patch gets it booting again, but I'm sure it's not the right fix.

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 53749d3a0996..1a1abda6af74 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1587,6 +1587,14 @@ static bool access_ccsidr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
        return true;
 }
 
+static void nv_reset_val(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
+{
+       BUG_ON(!r->reg);
+       BUG_ON(r->reg >= NR_SYS_REGS);
+       if (vcpu_has_nv(vcpu))
+               __vcpu_sys_reg(vcpu, r->reg) = r->val;
+}
+
 static unsigned int mte_visibility(const struct kvm_vcpu *vcpu,
                                   const struct sys_reg_desc *rd)
 {
@@ -2190,7 +2198,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
        EL2_REG(CONTEXTIDR_EL2, access_rw, reset_val, 0),
        EL2_REG(TPIDR_EL2, access_rw, reset_val, 0),
 
-       EL2_REG(CNTVOFF_EL2, access_rw, reset_val, 0),
+       EL2_REG(CNTVOFF_EL2, access_rw, nv_reset_val, 0),
        EL2_REG(CNTHCTL_EL2, access_rw, reset_val, 0),
 
        EL12_REG(SCTLR, access_vm_reg, reset_val, 0x00C50078),

Thanks,
Joey

[1] https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git/commit/?h=next&id=96a4627dbbd48144a65af936b321701c70876026
[2] e17d182ad3f797f01947fc234d95c96c050c534b
[3] 99d6b11b5b44d7dd64f4cb1973184e40a4a174f8
