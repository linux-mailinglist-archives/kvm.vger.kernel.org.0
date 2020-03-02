Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0EA31760C1
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2020 18:11:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727329AbgCBRLO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 12:11:14 -0500
Received: from mail-eopbgr770070.outbound.protection.outlook.com ([40.107.77.70]:34378
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727202AbgCBRLO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 12:11:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FIw/NK1qutgnqfj04IrU3ervR+Yo9KEZ1N4g00Aa4NrkdcoZNAsx7Bcro2Y+cKf/llyzWs7BLVudibOQKy0c8urTXuK/TDtYNZJZIEObL84Bgh89p9Wn9vkQIxMNQa7q04qnQIvIpjBP3hydCTlirM0Tu06jjMVjkIaioW7F1ZOMqMcfoA2Qau21t/af3J1VKPS9ZdNQs4GF9CAvnsvO/exyNBbDeEJkYskxfjwYQNHFWtZEHi6cgYaqQUWk0pNiFA3h3RJ1Ee6Fbsaqt9OfmiTRmQ9TUyFRs2D6WrJGgJ8r7M//6IBF088eCcxRKKCLESSrBoC8VA/yfpNQbak04Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=00upm7pp4pCNg5jrA+zVfvUcocOv37nxCOMXcpITBtM=;
 b=hqBlIbzLiLsJewWG6M2x0THJnZskKmj1Zsp2jxQlioSoYPrk3Jquu8VUbMdZWbdSakh0yoV8sOAQ4H9vh0mvfNCcpMU2nW2TwmW4Nicjo6GpykmxiWgGWpgKX5Qb3yzjfzxxEfHiUOUvypqN8JHWNDBcme66Tmtp5lAdg9P1ralH6SBcSVneMCgvKoJ/2Jd8LU04k9T7mv+KbtnJWM0pdWf9aUTLPrmMAt4NO7vac1wGJWsS8NWIihzYGh1+iiCffdktAYbSJ4qIv8s9bqJR3pXDAL5VwKU9mof331SYThJ03VLx6OuM4daROh6WksTSdQ9px+58uOqev6nudTPO9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=00upm7pp4pCNg5jrA+zVfvUcocOv37nxCOMXcpITBtM=;
 b=xIC3g8xbjbXElbw5/0hxRqps7NtOb+EJflGU5JOVtkee1J2UdRMR1tw7dczGjjtBBC18/fBY7SIslAmYFQfnOhk5sB1+dacIoj3v30CMIi+tvoQb4YRGgWFevdqhTuz8HAX06nVYcgU8LnLfz8vPuEGSCC7/+cn6DsTOF3CQcEo=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Wei.Huang2@amd.com; 
Received: from MN2PR12MB3999.namprd12.prod.outlook.com (2603:10b6:208:158::27)
 by MN2PR12MB3007.namprd12.prod.outlook.com (2603:10b6:208:d0::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.18; Mon, 2 Mar
 2020 17:11:12 +0000
Received: from MN2PR12MB3999.namprd12.prod.outlook.com
 ([fe80::54b3:f596:c0d9:7409]) by MN2PR12MB3999.namprd12.prod.outlook.com
 ([fe80::54b3:f596:c0d9:7409%4]) with mapi id 15.20.2772.019; Mon, 2 Mar 2020
 17:11:12 +0000
Subject: Re: [PATCH v2 2/2] KVM: SVM: Enable AVIC by default
To:     Paolo Bonzini <pbonzini@redhat.com>, Wei Huang <whuang2@amd.com>,
        Jim Mattson <jmattson@google.com>,
        Oliver Upton <oupton@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>
References: <20200228085905.22495-1-oupton@google.com>
 <20200228085905.22495-2-oupton@google.com>
 <CALMp9eRUQFDvZtGBGs6oKX=-j+Zz6SV8zTpLPukiRjmA=nO0wg@mail.gmail.com>
 <6487d313-dedb-1210-1c7a-160db2c816ad@amd.com>
 <af610180-d7fc-5a62-029f-0e27980c4037@redhat.com>
From:   Wei Huang <wei.huang2@amd.com>
Message-ID: <cf351926-e136-1974-fda9-27427ed18a53@amd.com>
Date:   Mon, 2 Mar 2020 11:11:08 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
In-Reply-To: <af610180-d7fc-5a62-029f-0e27980c4037@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0201CA0010.namprd02.prod.outlook.com
 (2603:10b6:803:2b::20) To MN2PR12MB3999.namprd12.prod.outlook.com
 (2603:10b6:208:158::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.248] (165.204.77.1) by SN4PR0201CA0010.namprd02.prod.outlook.com (2603:10b6:803:2b::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.15 via Frontend Transport; Mon, 2 Mar 2020 17:11:10 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 233abd74-b3e3-4634-c447-08d7beccb545
X-MS-TrafficTypeDiagnostic: MN2PR12MB3007:|MN2PR12MB3007:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR12MB3007FFF335CF8AFE772387E6CFE70@MN2PR12MB3007.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-Forefront-PRVS: 033054F29A
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(136003)(376002)(346002)(39860400002)(189003)(199004)(52116002)(8936002)(8676002)(4744005)(66946007)(31686004)(66476007)(66556008)(6486002)(5660300002)(81166006)(81156014)(36756003)(956004)(26005)(478600001)(316002)(31696002)(110136005)(54906003)(4326008)(2616005)(2906002)(86362001)(16526019)(186003)(16576012)(53546011);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR12MB3007;H:MN2PR12MB3999.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uYmbM5FKeQGgmGfN9HyNGZdtVnNMScK31f4YnY2VDeZfmoqTxrR1kOGye+82agnNyeU5TAc5yJJa2ayVPnOcnOjCGHVknAJPd+kxKSonfJKlD5IFfwXAeyXTYHy8yZvJ/eSzP/fDLhXvdCoREqMf6vuxQxkf7KzJYObLlz7TI0ECuO+dgwHyCBt8CyDM6DkH5TBuwGu9PZYnarblHMrwRBTd9gfhjI7r+g2GoHoURRAgJxJkVjgMxw5D0ZB06+jVe2WTq1v5rWktYBT8dtEHNGesiptJDU78Xi9igX4Ndi51hcxrEP15cx6rz6yV33BACFQUveB4oM71o+HSoBhpM8NOaQhBzuRODnGzza57IN9mYKAu2F0jIKpXSgIX6/F67xlUk9HjVlmWZaE5oERYqXAGn3mxzDCgus98xTN34DCxdOf59d8lObfcjiPZulJ6
X-MS-Exchange-AntiSpam-MessageData: FXtgRnezqqEQpOx+6Mq95KJDd0ZAV69jpwJD9w7vJnLC1gBCnLLFiX730D71imkXOnY3pJwNlya8Bjrj8dyOrqbQ4xoBjVuG8kqaOhFFFO/KleHwF8+O3L4qS1KNxojBG5lM8ExWLyyBQyoBH+nFDA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 233abd74-b3e3-4634-c447-08d7beccb545
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2020 17:11:12.2137
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0I5lI1YgK6o2fnPZblqpyiML2TTrhh2nRkFXgoubb0zdJuSAgor5yZcugq7qp4H7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3007
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/2/20 10:19 AM, Paolo Bonzini wrote:
> On 28/02/20 23:47, Wei Huang wrote:
>>> How extensively has this been tested? Why hasn't someone from AMD
>>> suggested this change?
>>
>> I personally don't suggest enable AVIC by default. There are cases of
>> slow AVIC doorbell delivery, due to delivery path and contention under a
>> large number of guest cores.
> 
> To clarify, this is a hardware issue, right?
> 
> Note that in practice this patch series wouldn't change much, because
> x2apic is enabled by default by userspace (it has better performance
> than memory-mapped APIC) and patch 1 in turn inhibits APICv if the guest
> has the X2APIC CPUID bit set.

QEMU will work fine with this option ON due to x2APIC, just like what
you said. If you feel other emulators using KVM will behave similarly, I
can revoke my concern.

> 
> Paolo
> 
