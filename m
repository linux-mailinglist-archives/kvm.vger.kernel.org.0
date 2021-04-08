Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80369358FCD
	for <lists+kvm@lfdr.de>; Fri,  9 Apr 2021 00:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232819AbhDHW1T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 18:27:19 -0400
Received: from mail-bn7nam10on2083.outbound.protection.outlook.com ([40.107.92.83]:9920
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232265AbhDHW1R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Apr 2021 18:27:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HKNIggmVdIWWvWSdGLqxGU0yDQ+ZxEIsbyunZIUY3765sIDNTBUlsyfEjuwAHbI7doSQNydXBNPyrKc2P/6pKJpsBWbULcpn5mgJBGDsJeUEitIpeFgAP6Rzm0eRoZ8HZkeyFtrHkMb6ArK4WYCKJih5vf0sGFepZ1UySySDzIy69a4qlPLyE2brhh4rTqLYo4tXbgT2ojOIQ5232iBt7dAkCjyesNXe4qbByqKFOk/DVThM0jyxR/0oWfgVaTZ5YF8SYRK5jqgNVr7xJ0LJNwg3G3z80Tb/eWHaZqOeyV6DOULKEXlyuumM/oYEjWOBzV0iGh3gOWVKB127F/32lQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l4KHK30uH82BzfRvMShn76XIjl7P3tFyTPMSmQPn01E=;
 b=PtIoGp0Ppd9P1sXknK4IGNw2yNlr4i2Br3weEGbFzmAfN8Za1yW+8eH2xSeJ7p/W907kNJCwQG/PP6HA1frgPFSRUckBBjcMU/9nuInMAfVChsEycz3W5qSa0x4K8rWrYfZoGxfr7kazkqsPHJ2WmjQttpD4+mAnKQo95mMSAwmcvx+41228hSmGFvf3b787+LFKCjZaF33Ru122cG5zRi3Qsm5Vv6MaAfdNT2glucvyB1+LThLJ51jgQYLz1K6xTtelQ7tSPfii6UG8T0bcW6+fZj9ZEDgpczFKQ2Z24mL/v3ebgCNeRyzJOlBR5yOr+CV679lNKAU93Ru9BJ1kBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l4KHK30uH82BzfRvMShn76XIjl7P3tFyTPMSmQPn01E=;
 b=NBpQCJqn+jn4OmWqIbNTN0CXMKh0kPq3mEiHNyy7goRIK0L8jkM53CNsBjlpBkqTbmV9G5x5wrqHX5UpIf7WFvwydgKDkm8YD5wy82BKHONBS9XYzhmDKyqe4hrOyOfbJWRlGLm/cIxwdRrS4dXIbnN+Mlbq7p9Wm8bGDh1eASM=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4349.namprd12.prod.outlook.com (2603:10b6:806:98::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.18; Thu, 8 Apr
 2021 22:27:04 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4020.017; Thu, 8 Apr 2021
 22:27:04 +0000
Cc:     brijesh.singh@amd.com, linux-kernel@vger.kernel.org,
        natet@google.com, Ashish.Kalra@amd.com, pbonzini@redhat.com
Subject: Re: [PATCH] KVM: SVM: Add support for KVM_SEV_SEND_CANCEL command
To:     Steve Rutherford <srutherford@google.com>, kvm@vger.kernel.org
References: <20210402014438.1721086-1-srutherford@google.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <18c68409-5fcf-2f2c-61f2-e8e52aab277e@amd.com>
Date:   Thu, 8 Apr 2021 17:27:02 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
In-Reply-To: <20210402014438.1721086-1-srutherford@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: SN6PR01CA0026.prod.exchangelabs.com (2603:10b6:805:b6::39)
 To SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SN6PR01CA0026.prod.exchangelabs.com (2603:10b6:805:b6::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend Transport; Thu, 8 Apr 2021 22:27:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 28fc2458-ec00-4a9a-1051-08d8fadd6fa7
X-MS-TrafficTypeDiagnostic: SA0PR12MB4349:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB43497E30DF2BB0E407A6D4BDE5749@SA0PR12MB4349.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TLg8KvarrS5B7Fj3h21NQyO/iAhsG0OViJPTOBJgRr3kYAwwqNPyEkCcmvOLYHhKg/07r62YpTTHbKlgTYQSXwaqk9B5/20hl8H2U8sgiXn/FXPxmqzumqaydgA0Oujz/TDd8NIK7S1M+4lV0XrgE0YzLLuN0ZuelTZFtlvvUuoMZZ+zpHBnCmsB4FH9n1tQFxSwgN6cWyuBJ2DHSj0nEqeB0UxFxJFtF7e1l9FdRNQ3dT3cYq/lrk2Y0bFVmfE9yZ+7xxI7S5R7+LBMw7AjNnm4DwoC2Rwfuka5t3GxQIwbnCXKnxuijxe0tcczYggAWuJqeKqJPmhVkbSAhx16qPsSaFNIhx6bDLU9jQxgjf/GmKk+HHMHoU5qUvG7bV+yPV18YhOm2nrSnezUiwMQIC9gwh53bJICsPDc1TCZXQoodtLrGtFuVTcOwIXvqUmmZaT/cJ0ad6pvVT3MVqJpors6wLf1tBVB5XC2kukorXpQgz0XRLElKhnnZLWD4sTp51VmQZaK8jk6nFDE9NauriE2ULMkxB/DtDM3LHw3tMBaEUl2ED7/IYrCf54W5NzYiLNVuGuWadCpBuZ/tm5FkSYtvZ7wVptqaEtI6IWRtviuGiE8SdUKbCRk1TYx9ff8HD0lFm0almx3lrNL6UL6m1w1HGV+EEncqAkJ/9FUHwWja6S8VgxaAoo2V71nn1siVGkF9N7s1QWrUZV8aYz7uwy6s9x4I2zxWq7j6fbt8dI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(39860400002)(366004)(376002)(346002)(478600001)(8936002)(26005)(44832011)(6512007)(66476007)(186003)(66946007)(4326008)(66556008)(8676002)(52116002)(2906002)(6486002)(5660300002)(38100700001)(6506007)(53546011)(2616005)(38350700001)(31686004)(956004)(31696002)(16526019)(316002)(4744005)(86362001)(36756003)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?WWFjbjNsSE42UTZhUE51SGxGTHc1RXFtb2xqMkNueGlFY2VlSis4MmJ3cGhG?=
 =?utf-8?B?OHhXdloyV1dVNm52bldkbFpiMVZpRjVoTU1Sd1pQT1owZ0ZMUy80U2NrOUdr?=
 =?utf-8?B?UmpPbzcvYWJZWFNpbVNtZEJKazVObEhBK3RLcW0zUVRKU3QzQTMra0ZLMEFI?=
 =?utf-8?B?bS9QNkRKRitiSTgyczBKM3VlQ1RFU0tZRCtManBxTERYYUF0ZUNKMzNjMkdk?=
 =?utf-8?B?L0hLejh2aUdKRmo2V1NJa2VMekZzZFdXZEsydEhmSEdZSG5DWHlzMGUyb3g4?=
 =?utf-8?B?cjNrM1pacWt5N3Irb1hTb3BnSlh1MHpDUFJXbjd3MS9QZG02VmRDeUhpQVN6?=
 =?utf-8?B?UmhWL0JCaGduemxxUDF2VmxyNUdkOXZVQTA2OVFXUjRad29zR2E2WVNRNHpa?=
 =?utf-8?B?OGJZREowL2ZWSmFLTm44aGVQWGI0SEYxUE9mVUhDK29XdXVCNUQ0L3BjOUFi?=
 =?utf-8?B?OFl5YlVnWGNEUmZMRFhJQk5wdUtLdjRENVhweUxzUXc5WlhIRmtlc0FDMWpH?=
 =?utf-8?B?QjM2VjlvblVzWlNwYUQrd0FSc0RnaTVTQ1Uzajh6QlBGS2xWYVVkSWhkTXll?=
 =?utf-8?B?YWpuZ0tNbWx2QlhLRmFGZG9uVDV3R1BkSTdhb1c1MU1jZ3hZeEZIMFVWb1FT?=
 =?utf-8?B?TmR5RXdIUDdBL3RCbFZLekVjRjRmK2ZGVUdORXV4OWJDeFNNWE44cHYyWGo1?=
 =?utf-8?B?T3Y1a21IWTlzRWdNcDRXT25ZZGFyVHdEQkpoT0FhTFFxMXFwRmpDRUxadnZt?=
 =?utf-8?B?TzNVL2xPUmFmaVlGdW8xQzFZam4rdnY5M0pESnZJbjA4T1k5Zm53bG45eUpH?=
 =?utf-8?B?TW5hbEt6dDBERHJrcEs3SVZVTlA5WjVmdmdqVGxVYWJ5WW9IeW04RE5ieTM1?=
 =?utf-8?B?NGNZUjl2dlJTbHp4VGJKbUllNU9oWUpOTDkySmpwcEU2Ly9TWW1VS0J3MEZ1?=
 =?utf-8?B?UmtKUWpHaS9NUi9NVHBqdzJaWHpycE54Q2lla3lSVjBXZlgvZEQrb0lCNkxF?=
 =?utf-8?B?Z1BqbFhqOXVFK0IwOGNKVDNjZ0IyTEhYbUlaVUVsV0RMMk8zVGo1cnRqM1Zh?=
 =?utf-8?B?VE1hR3g5VE8zZ0NIZjRGNWlFTXhickY5RFpuMm5weklGNEV4c0FRTXNDY1VK?=
 =?utf-8?B?aUw1aFRDM3Q2MEZ5Vzc0ckovQ0xrVHlFSWRaT0t5ZlBhalRWTG9YVDJ4ZWg5?=
 =?utf-8?B?OFpVcGpsN1daYTZNVDNCOGtxeHdEZkxIZjNhbEFaL1BXNVVIL1hvZzc5Ulkr?=
 =?utf-8?B?QjVpbXptUEdXVEE1VzU5aTZPU2kvTTRjQjRpdmcvS29JdlNDT1Qyc1FBVWVi?=
 =?utf-8?B?VDZLM0pZVjFMQnVFUU5qZ2Q1WHdqbktsbVByZHZPblo5WlVtMFgrN1Y2SVlZ?=
 =?utf-8?B?Q3FiT1ZNMWMwTko5TXh3a3JGSmx0L2tHdEM2NVE4aWhYOHBraDU4RnZrTWJX?=
 =?utf-8?B?VFhWanFEeFd2L29RU3luQmFFQ2g3RWJEanpXcDBKK0pTRCtFeDRXNlN5emlv?=
 =?utf-8?B?ckU2OU5OVG9YY3o4L1NWb214QzErcFl6LzZEUzFDWnh6MG9yVmpLSVRCbGg3?=
 =?utf-8?B?eitHYmdsZVRqdU1iRUpyZDc1TW51dkFLamIxc1pieGNPUE9UQ3hTc3o0Ti9p?=
 =?utf-8?B?UEJqUyszemJlNmpBWWpKcEw4eWRLUXBnc0dKN294VW5veVl6bmlBL1R0VFFP?=
 =?utf-8?B?dUlOeHJockp3SWprOTFuUXpINmRROWx4b1R4eXF4Y3N3bUdhQ3AwQ1hLUlpi?=
 =?utf-8?Q?pcTfJm+b7h2W42S7KF9waUzib54lwN2q5zNBKNc?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28fc2458-ec00-4a9a-1051-08d8fadd6fa7
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2021 22:27:04.2510
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JN8JAK43MhydsYMsVBVXUaxFXCwgHS9h18eZzd2sNUbelwcKGY80+LIkxXWFFofOSGtXGzUo6p/ymIcbUmZK0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4349
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/1/21 8:44 PM, Steve Rutherford wrote:
> After completion of SEND_START, but before SEND_FINISH, the source VMM can
> issue the SEND_CANCEL command to stop a migration. This is necessary so
> that a cancelled migration can restart with a new target later.
>
> Signed-off-by: Steve Rutherford <srutherford@google.com>
> ---
>  .../virt/kvm/amd-memory-encryption.rst        |  9 +++++++
>  arch/x86/kvm/svm/sev.c                        | 24 +++++++++++++++++++
>  include/linux/psp-sev.h                       | 10 ++++++++
>  include/uapi/linux/kvm.h                      |  2 ++
>  4 files changed, 45 insertions(+)


Can we add a new case statement in sev_cmd_buffer_len()
[drivers/crypto/ccp/sev-dev.c] for this command ? I understand that the
command just contains the handle. I have found dyndbg very helpful. If
the command is not added in the sev_cmd_buffer_len() then we don't dump
the command buffer.

With that fixed.

Reviewed-by: Brijesh Singh <brijesh.singh@amd.com>


