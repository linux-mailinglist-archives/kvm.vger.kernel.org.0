Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D1BE7AB717
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 19:19:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbjIVRTI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 13:19:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbjIVRTH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 13:19:07 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2074.outbound.protection.outlook.com [40.107.6.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0940192
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 10:19:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lHinfWB7F7UNHMfzW+dVMGIepBpgD1m5mU4y52s1VIo=;
 b=REBWh60QGLCTopW7HpoaNTcRtzYsX1Czqj0nI0uDANwtRnrWzEkRGVMpQEVKyar1wqg8h+HTBOmg716HRNvWNSKFONI453nc2NxhOzzsaNixOW2KrS5yFQRb+P0mF6EZ/3zLBHC6Ski/cnZEcGakTTHt5+VxEcwmgQCSs45eSk8=
Received: from AS9PR06CA0641.eurprd06.prod.outlook.com (2603:10a6:20b:46f::27)
 by DB9PR08MB6746.eurprd08.prod.outlook.com (2603:10a6:10:2a0::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.23; Fri, 22 Sep
 2023 17:18:56 +0000
Received: from AM7EUR03FT016.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:20b:46f:cafe::53) by AS9PR06CA0641.outlook.office365.com
 (2603:10a6:20b:46f::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.32 via Frontend
 Transport; Fri, 22 Sep 2023 17:18:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM7EUR03FT016.mail.protection.outlook.com (100.127.140.106) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6813.20 via Frontend Transport; Fri, 22 Sep 2023 17:18:56 +0000
Received: ("Tessian outbound b5a0f4347031:v175"); Fri, 22 Sep 2023 17:18:56 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: c121c9c51a03263a
X-CR-MTA-TID: 64aa7808
Received: from ff6403ab771a.2
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 5C8EF3A1-9380-488D-A63C-8CF01708A8A6.1;
        Fri, 22 Sep 2023 17:18:45 +0000
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id ff6403ab771a.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Fri, 22 Sep 2023 17:18:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k4pXWqgs6nKz2t/Pw40LgYukg601trpKnVwHBA9LCQPn3QcFJHg/dx4cRC7hln2W57D05prsXTjgzvuDrwCbDkMqpa7zB0H0YvHNnbs9+ygJ9pq0EBE3B5vQsOgiA0EPdF7OrB1lQFSRY64RU/LXCKhk68H5vE/KqknYBfI8lDwiYbnQMyPv7SiqsJnBpeAVuAgluH3HYCuRQ6RB/wHQX7Ee4sgtaBbZCwjOm3jhv98zBGCCQSH3oNC+dnTkk22nVwKAmt7uBTcd9EO5DsqTz4Clea+pEjOzmUd1i5LQf0cgfjn18b7dZc6sH/PL7qrGVNr6izapk/JdfhTreVE60Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lHinfWB7F7UNHMfzW+dVMGIepBpgD1m5mU4y52s1VIo=;
 b=Wir98c4l/+SY/CQNmSWH52uiFIvoYUXwln0eMpRAOiUmphA9qwaSsetHY3BldwplgJVPHv3OkzVbLEXDeFyA1Bu1rpGhM54Bgy2sSsV1+0d4XyzbEC329vwRf8/NdPY+q8Bvv4lP4Z9oEv/LrOfQlDVMtS3rRq721PDez9sLyIgZL5zBzyeCGmdPEJa131VhiS65CdEQVjhxWW3q1VBypGTkCFCjrbX52GVzHJhFoiMa6bNUbJpoEhDkPwoFboQZHmF342DIjeXImzKgJ2T+XT3MCbkFo2Xob92mVPYB+MMKDA5wiKYtpLHzVnvQOy6PRtp/9wvLGyhIzbmi3ltnRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lHinfWB7F7UNHMfzW+dVMGIepBpgD1m5mU4y52s1VIo=;
 b=REBWh60QGLCTopW7HpoaNTcRtzYsX1Czqj0nI0uDANwtRnrWzEkRGVMpQEVKyar1wqg8h+HTBOmg716HRNvWNSKFONI453nc2NxhOzzsaNixOW2KrS5yFQRb+P0mF6EZ/3zLBHC6Ski/cnZEcGakTTHt5+VxEcwmgQCSs45eSk8=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AS8PR08MB6119.eurprd08.prod.outlook.com (2603:10a6:20b:290::10)
 by DU0PR08MB8255.eurprd08.prod.outlook.com (2603:10a6:10:411::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.23; Fri, 22 Sep
 2023 17:18:41 +0000
Received: from AS8PR08MB6119.eurprd08.prod.outlook.com
 ([fe80::72e:658e:6a4e:2ede]) by AS8PR08MB6119.eurprd08.prod.outlook.com
 ([fe80::72e:658e:6a4e:2ede%4]) with mapi id 15.20.6813.017; Fri, 22 Sep 2023
 17:18:41 +0000
Message-ID: <80140d61-82e7-2795-409d-2cf6dc4993bc@arm.com>
Date:   Fri, 22 Sep 2023 18:18:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v10 06/12] KVM: arm64: Allow userspace to change
 ID_AA64ISAR{0-2}_EL1
Content-Language: en-US
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Will Deacon <will@kernel.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Jing Zhang <jingzhangos@google.com>, kvmarm@lists.linux.dev
References: <20230920183310.1163034-1-oliver.upton@linux.dev>
 <20230920183310.1163034-7-oliver.upton@linux.dev>
From:   Kristina Martsenko <kristina.martsenko@arm.com>
In-Reply-To: <20230920183310.1163034-7-oliver.upton@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: LO4P265CA0142.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c4::16) To AS8PR08MB6119.eurprd08.prod.outlook.com
 (2603:10a6:20b:290::10)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic: AS8PR08MB6119:EE_|DU0PR08MB8255:EE_|AM7EUR03FT016:EE_|DB9PR08MB6746:EE_
X-MS-Office365-Filtering-Correlation-Id: f2d30502-0ebf-43b1-7df8-08dbbb9000ce
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: V11DN8T1nANzt9dkd/2roBZnzvfoNqot/sM9pjSSvk5rz9qdV23oH4FSEM4dXj0XxO8P7YdvpfO/Zwd5ncQjvxj9zvDJiUH3GxWPGNRVhCq82pe2CEicYgx1uRECs92dpeSobsg38WuCb3mK+IsRO56F8A1Xv2KslPNDAwOIZc0MQHDvJbBNbkMfXPSs/LjaAo8d612yu8FLjsuFP4IpHYmn2kBjgPu19exjUZ2Jk38kzwCdEtaxhKKkSYAo5jEULvWkQVvkDE7CtCYRxG17aWFtHv7wF/6/k8VB9rNw1yx7N0cUbIABnVE4RT/NBC/L7wZ3LEUcoHxspye/slTtfNPrQI6J+dd+mL8uv557qFXkst/4puBuDAvCbPCQEXpVbt4/MnidnsusS/hPldA+z9phoJoFtyk4P5EPrzmVfmPvXd7Yq18W4kwNcF9dUuGOfkPhUvr5mRwR81nIFP97ps8cp96tOz8cgn6HIb9VqxTjZl88lr960SqDrkWRFMTAQ5zuDMGrUZZwDShdDCbTbZCTQsdyaaNZkM5KVijq0D32eoSz0zz2kPzunO2h42aG6GUVlqYilgsb2YCIf3VD/no21vmjkpZUfdDkQgDvDG9X8TyLWh5LJJSSH9f5ou4LKhFsEGldYoioO2HzdR+39w==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB6119.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(366004)(376002)(396003)(39860400002)(136003)(186009)(1800799009)(451199024)(38100700002)(86362001)(31696002)(36756003)(478600001)(966005)(2906002)(6666004)(54906003)(6916009)(66476007)(66556008)(66946007)(6512007)(2616005)(6486002)(6506007)(4326008)(53546011)(8936002)(8676002)(44832011)(5660300002)(31686004)(316002)(41300700001)(83380400001)(26005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB8255
Original-Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM7EUR03FT016.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: 77ae5f1f-507f-4b27-c38a-08dbbb8ff717
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lE4zc7PD0gx2OvNrvO6nMnQIlBk0JF/hK12duzYG1b4//j02krLJuh2czY74nH0OAxdzymHRYaRqZlBVBBZwp7UKSKoDKuwLcWKWefDzEqnqHyEC9sefPtZlbyQ09sTZhLEpDWOpV+reznnCoZK2xEMQNTjiuA4VENTGd8JlEWlbNKv7o7pVnNSoLHxBWnXwGMpzyhGBhO8CSZ+WrgDIMwcF3IZNJOnBgdTAZK2riY+BWX4XJXiniYe+OkmwJG7wrkjbr4ls3HFCPn6bqbIeU7QCTdC7YyxZ5lwDGH581Vd+V42pgSahPz/wUT8LtHEp00a/iekK765x/qgCHjroP4T5myVJ2qus5rYSTN6sSnX86o72ge0bMoi6jhigwwLcnpEABNt/nXpzGMp5XiyI/19yzwCIgg/8Iids7W3H4ZsCxI3wcNONOKPTTpnqpewMO7IaUemYSRTD6cEisTrPTtJvd5BDKdf6Dr1dw8NCwkRCcP4VkXlGiSuSupiiKuO1HURkomZMHkAnvw1GmpzKpOzLuco/ajo5LVALIqB3jC3AWt8UHOC7d5/V3ZRy5lLqdlDuXZBI6AP5jp8FA9vNhipnph0B7Ul1C9RQi0+xsC2U6MNhP9V0S/a2Lbj1JUY/+Y/qzr26lrFVp2yHGnIOdri75r/tVqcxDpp28dpK75Lp4B/0ZFkjpabquKAGU0BMLexXntk8j0zd87SMezv+iwLWZpb3Z8xB/co/gxZI3owighZvVy1rx688TbJXPrVrz/tYURzBMX6PHJEiWpqFimyX+7i04mXir1VjvuJSul4=
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230031)(4636009)(136003)(346002)(376002)(39860400002)(396003)(1800799009)(82310400011)(230921699003)(186009)(451199024)(40470700004)(36840700001)(46966006)(54906003)(2616005)(26005)(107886003)(6506007)(6486002)(31696002)(6512007)(86362001)(40480700001)(36860700001)(47076005)(356005)(36756003)(81166007)(82740400003)(336012)(83380400001)(40460700003)(316002)(8936002)(8676002)(4326008)(5660300002)(44832011)(6862004)(70206006)(70586007)(53546011)(31686004)(2906002)(41300700001)(478600001)(6666004)(966005)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2023 17:18:56.5649
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f2d30502-0ebf-43b1-7df8-08dbbb9000ce
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: AM7EUR03FT016.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB6746
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FORGED_SPF_HELO,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/09/2023 19:33, Oliver Upton wrote:
> Almost all of the features described by the ISA registers have no KVM
> involvement. Allow userspace to change the value of these registers with
> a couple exceptions:
>
>  - MOPS is not writable as KVM does not currently virtualize FEAT_MOPS.
>
>  - The PAuth fields are not writable as KVM requires both address and
>    generic authentication be enabled.
>
>  - Override the kernel's handling of BC to LOWER_SAFE.
>
> Co-developed-by: Jing Zhang <jingzhangos@google.com>
> Signed-off-by: Jing Zhang <jingzhangos@google.com>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  arch/arm64/kvm/sys_regs.c | 42 ++++++++++++++++++++++++++++-----------
>  1 file changed, 30 insertions(+), 12 deletions(-)
>
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 10e3e6a736dc..71664bec2808 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1225,6 +1225,10 @@ static s64 kvm_arm64_ftr_safe_value(u32 id, const =
struct arm64_ftr_bits *ftrp,
>                       break;
>               }
>               break;
> +     case SYS_ID_AA64ISAR2_EL1:
> +             if (kvm_ftr.shift =3D=3D ID_AA64ISAR2_EL1_BC_SHIFT)
> +                     kvm_ftr.type =3D FTR_LOWER_SAFE;
> +             break;
>       case SYS_ID_DFR0_EL1:
>               if (kvm_ftr.shift =3D=3D ID_DFR0_EL1_PerfMon_SHIFT)
>                       kvm_ftr.type =3D FTR_LOWER_SAFE;

Nit: it shouldn't be necessary to override BC anymore, as it was recently f=
ixed
in the arm64 code:
  https://lore.kernel.org/linux-arm-kernel/20230912133429.2606875-1-kristin=
a.martsenko@arm.com/

Kristina
IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.
