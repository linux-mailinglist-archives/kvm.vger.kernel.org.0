Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C445917427A
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2020 23:47:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726277AbgB1Wry (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Feb 2020 17:47:54 -0500
Received: from mail-bn7nam10on2074.outbound.protection.outlook.com ([40.107.92.74]:8128
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726046AbgB1Wry (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Feb 2020 17:47:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZGo12Ib4XezsWMX6tZOyprIzzxn12d6/5EO9ddki1ZEsDuDguUDryznwOenS2PUMpxv6eR6krwJhpSr3tiJaIvkrwXyjLadLWN2rkOBOe48W+FjohYOEHMzQblKCewxwzbdwPvp97URBpfdUPJAj7r1o76Pli5ApsRwdGrbklqO1+9d7IhaeHZa16vmNpEmsDybzJ9DUF6Ft6Fg9KzwxQSzQHU7qChYLCWty2Bt/uDKo1qIldZ2ZhYRt3wo7DWbSgRuynYko1xO8pKkd6p7BO4AndKyz29dEya7bBRdF5Qe4435tznZHq3N31VcL080r4ECd2WFvV1hLksuhgWLo4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qc802e8N2QIB8oJJcBXP6ccWgj8ge4NvUHdacbUaUnE=;
 b=VMTtQKgSPoZf+hzrxQcG15HmAD2YsCkG3RSZOmmqd5g184V8UKEGRx5LB7phhrJ2KX1YNk4pNk7ihNyAdI7pY4JgskmXTz5fDsMjGFQXuFQoxBCs8kCHMz8IsPrihtTCAFR0TM0X8XtSgRV8tBQ0e/HTv5BrzQM7OIc3PZBZffM0doNGjQZL36FUKxNdAt2SYherldolCyltZa4fS5q5K7o6HqNtzvyxIMjiUpvg4CcthLq03qaVZGQ74L1PjfdTuJs67Cx1H0TEISR3PiqQCL2aM8FIQRf7tj0GhQ/m543750vP7sW6PxUGc4HYUvoSKzFd2pE72q8OAiXm/AM17g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qc802e8N2QIB8oJJcBXP6ccWgj8ge4NvUHdacbUaUnE=;
 b=e6JJ5FSFJtqricK+2uW8455i+Oab2TnVbrropYmyGB9vI4+3sq8Fl3BR3HXgpnHkdxovQwrUYAdczYqgEpiL3xKZnGFZJ7a0cRIuUpmKuaVUD+MDLKbqujDNuofkyOuVz32/8IdbemAcaSqA42yXsAhCcJGrqOM6pBONI66WydI=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Wei.Huang2@amd.com; 
Received: from MN2PR12MB3999.namprd12.prod.outlook.com (2603:10b6:208:158::27)
 by MN2PR12MB4439.namprd12.prod.outlook.com (2603:10b6:208:262::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.15; Fri, 28 Feb
 2020 22:47:50 +0000
Received: from MN2PR12MB3999.namprd12.prod.outlook.com
 ([fe80::54b3:f596:c0d9:7409]) by MN2PR12MB3999.namprd12.prod.outlook.com
 ([fe80::54b3:f596:c0d9:7409%4]) with mapi id 15.20.2772.018; Fri, 28 Feb 2020
 22:47:49 +0000
Subject: Re: [PATCH v2 2/2] KVM: SVM: Enable AVIC by default
To:     Jim Mattson <jmattson@google.com>, Oliver Upton <oupton@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
References: <20200228085905.22495-1-oupton@google.com>
 <20200228085905.22495-2-oupton@google.com>
 <CALMp9eRUQFDvZtGBGs6oKX=-j+Zz6SV8zTpLPukiRjmA=nO0wg@mail.gmail.com>
From:   Wei Huang <whuang2@amd.com>
Message-ID: <6487d313-dedb-1210-1c7a-160db2c816ad@amd.com>
Date:   Fri, 28 Feb 2020 16:47:46 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
In-Reply-To: <CALMp9eRUQFDvZtGBGs6oKX=-j+Zz6SV8zTpLPukiRjmA=nO0wg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN2PR01CA0062.prod.exchangelabs.com (2603:10b6:800::30) To
 MN2PR12MB3999.namprd12.prod.outlook.com (2603:10b6:208:158::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.252.23.94] (165.204.77.11) by SN2PR01CA0062.prod.exchangelabs.com (2603:10b6:800::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.15 via Frontend Transport; Fri, 28 Feb 2020 22:47:48 +0000
X-Originating-IP: [165.204.77.11]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: fdd64c78-075f-4454-e690-08d7bca03ca3
X-MS-TrafficTypeDiagnostic: MN2PR12MB4439:|MN2PR12MB4439:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR12MB4439E3DFDC2AF7D34FCE8B21CFE80@MN2PR12MB4439.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1227;
X-Forefront-PRVS: 0327618309
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(346002)(39860400002)(396003)(376002)(189003)(199004)(53546011)(52116002)(478600001)(5660300002)(66476007)(66556008)(66946007)(31686004)(6486002)(4326008)(8936002)(81156014)(81166006)(8676002)(316002)(54906003)(16576012)(26005)(16526019)(186003)(2616005)(956004)(36756003)(31696002)(2906002)(110136005);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR12MB4439;H:MN2PR12MB3999.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WCHzgTqwo0LZAXoNinPqKTKKjVgciilZf2M8Jq0b575MVFzeq6aW+aFiFiGdR4lyL8Y7hTMDuxZb2OOvCJvPKuPNxFnHtED2oG8Ikc15Ea9SqQ0py3OIv6Kqz8BYmNQ6Bzzoc19KuOsaS/j3zgTo9pdTsmiR4PylxQNz06mlOdlavBNnQhObPce+yptb+jq4/TpUbAcbbtA815v7mXINvM+uSKKG1r3xM07FQ6nM2o8HeAlJzUq1pe9pVS9ia94kWJcYp098jqHBx054cgJlMQ9wzWu+3UEcDenf6E3To/f9OOBzkGnrl+xpjYZohd7HtSQY9yaloKBjCye9I04/xHJyetXQE0zugEAzAoFBl1ijwlryRS04gIwCJBUdIOnK8Rh46jmoICwMWR7ARbZ23TlndO46zx0TmaIVIaVPMSxdpBnI1p20vEH/JbcmDTxA
X-MS-Exchange-AntiSpam-MessageData: TW+tCcqec6MpjzjnzyZE7Lv5DkvwFO/WQ6fLH1/CfLhnjiLTYFdW5wmb8ktluZH9GALMP746TN6G3q885fFUarJ2/oxtkV7EAiISobZxyPIPadN5ypm0PVnjJTj4pxCwUE8O9SFVkxsXXluFOp2JrQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fdd64c78-075f-4454-e690-08d7bca03ca3
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2020 22:47:49.6386
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Cz4rdNTHDgiZppmxXOVleM2XwfFwxwBIxGq2aBulGc9xqkJ2lS61bVZiZ9m/t4hd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4439
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2/28/20 1:40 PM, Jim Mattson wrote:
> On Fri, Feb 28, 2020 at 12:59 AM Oliver Upton <oupton@google.com> wrote:
>>
>> Switch the default value of the 'avic' module parameter to 1.
>>
>> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
>> Signed-off-by: Oliver Upton <oupton@google.com>
>> ---
>>  arch/x86/kvm/svm.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
>> index b82a500bccb7..70d2df13eb02 100644
>> --- a/arch/x86/kvm/svm.c
>> +++ b/arch/x86/kvm/svm.c
>> @@ -358,7 +358,7 @@ static int nested = true;
>>  module_param(nested, int, S_IRUGO);
>>
>>  /* enable / disable AVIC */
>> -static int avic;
>> +static int avic = 1;
>>  #ifdef CONFIG_X86_LOCAL_APIC
>>  module_param(avic, int, S_IRUGO);
>>  #endif
>> --
>> 2.25.1.481.gfbce0eb801-goog
> 
> How extensively has this been tested? Why hasn't someone from AMD
> suggested this change?

I personally don't suggest enable AVIC by default. There are cases of
slow AVIC doorbell delivery, due to delivery path and contention under a
large number of guest cores.

> 
