Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6267B1C34C9
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 10:46:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728317AbgEDIqr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 04:46:47 -0400
Received: from mail-dm6nam12on2081.outbound.protection.outlook.com ([40.107.243.81]:11584
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726351AbgEDIqq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 May 2020 04:46:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I/KcCgQA/nTYr2IJ6e2iIujz+je/1xyLzA2QLXDD1fYohqQJtep+AUQu57++mmD/lu0O98xtYiGYD97z1aBRmjsGVS2rgjQQUCW6Kk3Jl95iyRmZ+hlNqY+huTQgDwnFh0t14DOsUpuIAdzSBd/Xl73POduRSUzj+qlXfwv+qIQsY/upGpFK/E7+BE3cqUnLb/BA+JJ4FRwMUzYuyr0sgfCGX7TPsn/PtQql8RTefyrqAyP8GKSz9t+F+jEfUEx7qXc/Rj7/5WIelZHeZmbgVj2RHIysXiI/BYCE/WgrAeUltdm+d1TkJbdzGKyofXLa8/pSLRFb0pEyPMQKhFnKGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=13OCvDAIYJgJx8qmdxetZjYYsyPulJeXYYZeJTnOjq0=;
 b=nGaWa2TiNmHA3Wbx+62vLEglK9G5OaWZOYlslO8KgnQ71TTjxB2zzK7B2UsYaKjf3TLe7NEQgZSu+Cl0Zo6Ed3rpchz521xmkTjU6nr47iorLoOfjrcTHUW4YMXSzGqHA/QHgs+a8SAUab7WEWfTBs6e2QOOZF1xcnQrfZVXZTwai67JaMULapJuPDT5pYaqTXkhyWgzYOHfd3amaZsXvYI58121y5MGJv93GsU27v/o5vuWhco8wPd0WBytw4Ebhoc4xXm8X17p3memsF60tFd0cu53H+xUFpqdKRkUIERoI1FXxlRUyE0H1dHKERgC8XMBIQBJR0keEQK85WgPUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=13OCvDAIYJgJx8qmdxetZjYYsyPulJeXYYZeJTnOjq0=;
 b=jH6Yj6DRhGDKykBWIUu7ViRbX31yCrzjB/StgtZKOnTKtpGhQLATlnCmcte4J0vS8v4apk55FsUeehLO0aJst/Sl2MaZ9NJt7zJBmcWD+HpeR8NjNMhqAMwgqD3IIgMjC/74gpORhrDkIHt9k1SSNmV59xG2wlG96sTdB0Bv84c=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1163.namprd12.prod.outlook.com (2603:10b6:3:7a::18) by
 DM5PR12MB1721.namprd12.prod.outlook.com (2603:10b6:3:10d::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2958.20; Mon, 4 May 2020 08:46:44 +0000
Received: from DM5PR12MB1163.namprd12.prod.outlook.com
 ([fe80::d061:4c5:954e:4744]) by DM5PR12MB1163.namprd12.prod.outlook.com
 ([fe80::d061:4c5:954e:4744%4]) with mapi id 15.20.2958.029; Mon, 4 May 2020
 08:46:44 +0000
Subject: Re: AVIC related warning in enable_irq_window
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
References: <9ce7bb5c4fb8bcc4ac21103f7534a6edfcbe195d.camel@redhat.com>
 <758b27a8-74c0-087d-d90b-d95faee2f561@redhat.com>
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Message-ID: <c5c32371-4b4e-1382-c616-3830ba46bf85@amd.com>
Date:   Mon, 4 May 2020 15:46:35 +0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
In-Reply-To: <758b27a8-74c0-087d-d90b-d95faee2f561@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR06CA0122.apcprd06.prod.outlook.com
 (2603:1096:1:1d::24) To DM5PR12MB1163.namprd12.prod.outlook.com
 (2603:10b6:3:7a::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Suravees-MacBook-Pro.local (2403:6200:8862:d0e7:7c73:bebd:7e44:6839) by SG2PR06CA0122.apcprd06.prod.outlook.com (2603:1096:1:1d::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend Transport; Mon, 4 May 2020 08:46:42 +0000
X-Originating-IP: [2403:6200:8862:d0e7:7c73:bebd:7e44:6839]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2cbe73b6-8db0-46dc-dac3-08d7f007ac56
X-MS-TrafficTypeDiagnostic: DM5PR12MB1721:
X-Microsoft-Antispam-PRVS: <DM5PR12MB1721240658279753532391F1F3A60@DM5PR12MB1721.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 03932714EB
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cYBGOJn4y+F1Pv1cuzYUXFeo92jaUQWy7gQy/f/4N1/GoUpw6jyKP9+gfRnVE8XVya9VNmgwS3ILIj3erZEgMyXWtNgs+S29hmmyyplDrV8BA99l7VgCCkgJ5hh//46zfWztM9AIt9HY1feS/MWrv6BvilnEIROJSRGHLQ+YWFjO2ffz0b67EjxFJIMo+VXX+dXjemGCCW1CZE9myaOgrLEZeksyOjZ6PjA7DnkJSBhJ7yyUpSnMkm0jRccisTNCuNHU/TxkefphWwQvsSDOLoH/SuP+6ncH3yUfIyz+QtNHSx2qCIdZUNqA4EfuUcE1pVHfPLbiFf+942L+5klLcp5q6x1kQuVOu3vXjEvpZjn6URnuk+QrJIVvmA3SDMG5oRQQpAewQRyspnD3befMdDRHz2MJ9yKRiIfJetIA0SBs3cN6wukeLHfDxBj7vc7O
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1163.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(39860400002)(376002)(366004)(396003)(136003)(8676002)(8936002)(6486002)(6512007)(4326008)(31696002)(2906002)(66556008)(31686004)(86362001)(66476007)(66946007)(316002)(110136005)(5660300002)(478600001)(2616005)(16526019)(36756003)(6666004)(44832011)(53546011)(6506007)(52116002)(4744005)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ceotyYTi6Wf7ZHLE81GMz6l2t2V9C1sacWzq/gFCjEYN4fTtMdLkStEf4CIsX/UYovvJ8fNkQXtLVJ2JC8UCBY3Ax+JpnK6WuBBYNx8O+UMMDHMB6LCCIVtj72A9LzXN4EkvyREfc1ibbBdKYIMq8Ch6GRC2e0hQ0tk3bwZ+R601lZkZTNTRtq81II5Pf7Lafv4Gy+9k0Yxnm69qzOcEVGUHOSgOsHJzQ4k0I38CPilrO77U8DL7RiA5wYASGqiK6NrpFH+K8Hlz9vsqyg7cAGRGX0m0Z308HpHIOitdbYNeFmV9mesGv0rkRUbIXwWFT566PDUirIlj31lTESASzWS1IBT+shbj4t93DCotlx9Rg9MlHrwNAzo9jgVL05cnJC2fQTMGItuMh7xRTWbL6oBik8jEefwTkLKqKVIRWvGto4qb5MV1Mp924HKX2stx3rOO/u706KRsHBX5yIrCNSD3iOTP+CuK8NMCkSmhIHZl1MIKdiBt/KhFLdJYsJvc62OZL5M/hKIPz7oXKhwLoNBl9xDvH+0yOLo2GPsXS86GYKZuRCmfcE6688+hMWGVRihHD5PP92aBnLcnhmm71v87DcJYb0RTpcRyERqG9nhw7xDvMzBy+PUhlgYrUF627WdgX3+WJo3K14Y74LalzrwhNxroAgEKOSBOffMcTbi+kKWpANdsDQr5MFL4fE9oJB+IbdtgOjh3OnyDiC2ecfnQY95wnhiXrUf2Iu5MUzj4dIkO8Iz/NkJUCGF/tZf45oBzqn6/AM2/bub4bhMLPAf+RJ1EoYTfB+pUgdWCbea9Sa+2Tyv51TqyJCx1dabKfFF+reKAEnn+3Hhypk+7T/RErJsSO3Ic5ElW6pnAtDi6Z/HNGrrtl9wzhU8vfIz3
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cbe73b6-8db0-46dc-dac3-08d7f007ac56
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2020 08:46:44.5863
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sxqFAWVeE39BrCgDzd4o1BGEMKBjiOFOE2/FIvbAGG3+onSql5NC4vXOyR6WqcFgterqEBdQbWLLy4IEHLNN3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1721
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo / Maxim,

On 5/2/20 11:42 PM, Paolo Bonzini wrote:
> On 02/05/20 15:58, Maxim Levitsky wrote:
>> The AVIC is disabled by svm_toggle_avic_for_irq_window, which calls
>> kvm_request_apicv_update, which broadcasts the KVM_REQ_APICV_UPDATE vcpu request,
>> however it doesn't broadcast it to CPU on which now we are running, which seems OK,
>> because the code that handles that broadcast runs on each VCPU entry, thus
>> when this CPU will enter guest mode it will notice and disable the AVIC.
>>
>> However later in svm_enable_vintr, there is test 'WARN_ON(kvm_vcpu_apicv_active(&svm->vcpu));'
>> which is still true on current CPU because of the above.
> Good point!  We can just remove the WARN_ON I think.  Can you send a patch?

Instead, as an alternative to remove the WARN_ON(), would it be better to just explicitly
calling kvm_vcpu_update_apicv(vcpu) to update the apicv_active flag right after
kvm_request_apicv_update()?

Thanks,
Suravee

