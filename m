Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB668339791
	for <lists+kvm@lfdr.de>; Fri, 12 Mar 2021 20:42:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234307AbhCLTlo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 14:41:44 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:56010 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234267AbhCLTlm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Mar 2021 14:41:42 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12CJO8dN119563;
        Fri, 12 Mar 2021 19:40:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=12zReYUGH8cTfsWdFES/CawHZM1/espa2xktq1kRz2s=;
 b=KTy3GsGnk7hrr+UAyL5IklTUZLhmNyT4RQMi9Sv2VUm5EEFlbITaFndzI9ijn+9U0cO5
 Ylm0a2PTckAy7tmnDZ9ABgEJGEp40SQZ/XZXf88uWNXLS0VndbmJ8VrZTtdfX95pZCfg
 KXw5GUj2wZNwCz1A4hlJh88TBLhAWoqToa6lAI9zdoia7sA91oGLHLkqYzuVdnmecQkB
 GzbPBHm8/B71GbmNRU+A9h6JN4Rx/aYTQuBvYzW1jV4hc8KIHcolwubKbK/he/U/tfia
 9V65mdnzgM/Wy1J5E05IHhF1mhnzhaBE5/Jqe5NI1+P/fkZnJpNwodiZXPOmANEGw+JK mw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 37415rjws7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Mar 2021 19:40:24 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12CJXRxK087262;
        Fri, 12 Mar 2021 19:40:23 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
        by aserp3030.oracle.com with ESMTP id 378cb4qa09-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Mar 2021 19:40:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JIrdHyiyBh+OxYURiVMcb9/Llzi5J0abDaczB/QBLoVRsNbu/PVYszjTKPIdvsC5oTE9pV5kG8czISRIhGfQAPFhZs5luz0F6jQp4a0sKL+Vg/9+lzprVjoIv0rZllfJOjLaS0eaW29VDtqT8peMEe+UvWceq3ODuJmlerqfrstZrz/qdZmIO/7EtTacannFyOU/uB+fXMbCSiDKu0Fj52E8DghIL31TZtONYzsijbJgbplgzZpksrhzkjht0MVlNht/D/2oZniINwN8QAF10s8mQRBK6AIrpe3IBExR4eYEWs2EHHB00VydkaItAwR7Zbs4wsdENXHvO01jrT+3lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=12zReYUGH8cTfsWdFES/CawHZM1/espa2xktq1kRz2s=;
 b=aRLTNZgC8EUBYXN1E9+Iblz48E/8ES+y3QF/uBiIpXnTfMo2xhRQgl4Zpp5tYo2x2EebOpjKUmLba6y8GkfKwPqn6EEb/hvsHeavOacNNXNbnnKOoqhYMq7Z34PsEyFF+lnbLycEMBLKq0p5hquyZCO3w8BPj73gMScrZYpgt4JDXRU8+xC5m2tz1+h6ZnP+nVYIy7yBE7wjpz7mdJQ8wZo79pr19ZC67HRHGG17cAhoq8R9fh8Z1NsK9miq8i40G1f92LBiHd/lobGii/A8bLjkYNJ4ZhiZOELTsXFqXRmPvzcD6QI34IkxlAw/rwgQHS2XD2Pn/RmrL4X6KLIChg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=12zReYUGH8cTfsWdFES/CawHZM1/espa2xktq1kRz2s=;
 b=KpQDV65Oax/aZEuh+ry7aU5bk/oqWU8XmXuWlpVrJ0hh3+AxDvWkhQkwzMnUfurvZvJy5+5MSoJekSKziV5fVLsFr1aWshRjshThIy+EfeHN/iRNcIoyCFCu7SORi7Sc2Cx15ZheX40TUtFb6SCQWTLVSEZTxHYf5tq5Xp2H25U=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by BYAPR10MB3687.namprd10.prod.outlook.com (2603:10b6:a03:125::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.29; Fri, 12 Mar
 2021 19:13:09 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::44f7:1d8f:cc50:48ad]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::44f7:1d8f:cc50:48ad%6]) with mapi id 15.20.3912.027; Fri, 12 Mar 2021
 19:13:09 +0000
Subject: Re: [PATCH 1/1] KVM: x86: to track if L1 is running L2 VM
To:     Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        linux-kernel@vger.kernel.org, joe.jin@oracle.com
References: <20210305225747.7682-1-dongli.zhang@oracle.com>
 <cebd5f51-12e8-44e5-7568-8890343ca36e@redhat.com>
From:   Dongli Zhang <dongli.zhang@oracle.com>
Message-ID: <f0de2138-74f1-410a-f079-9d697ca6f145@oracle.com>
Date:   Fri, 12 Mar 2021 11:13:04 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <cebd5f51-12e8-44e5-7568-8890343ca36e@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:646:c303:6700::a4a4]
X-ClientProxiedBy: CH2PR18CA0053.namprd18.prod.outlook.com
 (2603:10b6:610:55::33) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2601:646:c303:6700::a4a4] (2601:646:c303:6700::a4a4) by CH2PR18CA0053.namprd18.prod.outlook.com (2603:10b6:610:55::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Fri, 12 Mar 2021 19:13:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 48c3b21e-11c4-4ce3-ad7f-08d8e58adf85
X-MS-TrafficTypeDiagnostic: BYAPR10MB3687:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB3687F7F26E05F1EC7C611C41F06F9@BYAPR10MB3687.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1060;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gj8SSRYPfYf30FE+FDRQOah4ATaoudZIsay9/+QB6PmTVqd2p+u9KW3rDpBANY7P8drzUPNbzhtEheGktzJ1D9U8fXnAwVybT7T+/AlP58iAZjYf1S7F367+VJ/5Kcp6BfyrlhTPJL4KqLd3szH1WaVcX35Ww9l1QrZVZal/W7usvYWB/76BUmZEc+mtVD7MDfU2KsBpXDhT7zG3ctQZyRk3Xu7wgITEr66VHQyGE8OmuODAAhZ2bOy1x70l2psoPLgTAB/5iIgiPuJKOUUSdAoK7p2by1LdxWc+nmQIBpNcNHELODk3bh6txICIM81FeI3noENOYZMRxcit1jcLl/CWGglBbdO0laqf7Ij+Ooa1rWZGh4EJeRLHtRhvO7SvBNBZd8M8ZXcMyDHQzasqTujlkpKjMkXHXO8u08rqUVPZArOm4Sq6cyUWjRLFFSYIHe7/f5/aE4fjdUazWZopWsXywVr/1kGmd6qZlCB2eN76m8Iq6BemSaTZCKSF72o+McY4p3aLTWjZpkaE92vyJx7ssDwhUrnIyxT0exgxg6P3tbbsgIXbAGY13TfYZaZIuC+Yeitn+oSJwZJ5ES1RKWr3iZR4vmj55bGTTrfjyB0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(346002)(39860400002)(376002)(136003)(7416002)(186003)(8676002)(36756003)(316002)(6666004)(53546011)(478600001)(66946007)(4744005)(44832011)(83380400001)(86362001)(31686004)(2906002)(4326008)(16526019)(107886003)(6486002)(8936002)(66476007)(31696002)(66556008)(2616005)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?SjM4a3MyeUY0RkpMbUFmVDNqZDFCYWNkLzRNTXV4VUFVTmRnV3lLVm9pRjZ3?=
 =?utf-8?B?TlFZUjRQa1NjR2RQZHVYYWlPcmdnQm5pRHpmNzBrZ21yYWhwZ1FTSFNwRTQx?=
 =?utf-8?B?TnN4TWlmcmRqa0RSTlFObGxPeVAyU1VjQ2tKVkpRd212aWo2MDFqT0Z2Y1Jh?=
 =?utf-8?B?YUg3cDFDdVdwOWQ2Wlpha3BlVjBPOXM3T01vblZPa2MrRmsvQW9IL3lyMEdJ?=
 =?utf-8?B?NkpiNm9EN1dndmtrYkZFVHlkZS8wVjNkNDAvYW1aM2pqejBmUWNDRnVVMDYy?=
 =?utf-8?B?VVpIVFVmZ09Pb0N4MFZkcU1ieGU2dkV4R2dsTEU3VFM4UWNHV2lUeW9LSHZU?=
 =?utf-8?B?RkdqbWtuZmdjTVRMS1ozSFhFWU96YzFFWkRCWG55SHVpTldHbks5Uk5HcTZ6?=
 =?utf-8?B?Q3NaNGJ3S2xLbEFRbXVEeUg2MU9PY3lNZjM2Z1N6UlJneGl3L2dQL3ZTV2JE?=
 =?utf-8?B?aEpKeDZNR3ZvUUdrRC9nK2VqTEtiNzdYZEVIVkd0bVJyQW8zSHdMVk9xMk9M?=
 =?utf-8?B?clJpb3pFQ2o2eHBZbld4UVdQN2IrZFRKNnlQRTlZZEQ3NjJIWDE4U0NwY0RX?=
 =?utf-8?B?Z3BDRXRqbVFYcENESHF0UWdudS9XdFVWdzQ5QkduRFNNbFRDUWNoS2FPSy84?=
 =?utf-8?B?YmJlTkl0RFJtQ3czVE95a3NwNmorM3BXYkRsV01OVTBhQ25uODQ3VVlPaU4y?=
 =?utf-8?B?ejErUG5FbG5GcU5VMkxIQTlkWnZCS2xHZmpTcEJCK0FXaE9MazJMcHR3K2R6?=
 =?utf-8?B?clRPejBrazd1KzUwSHcrUWwveWRCSTBTeXl1MlFvazduWHhUVFlFbGlSamJt?=
 =?utf-8?B?dm5hMWhodHNUWmtqZnY0WmRkVmRpWGExd1hlK2J5OUhqOUxLQlFSMjVyZXVx?=
 =?utf-8?B?d2VQZjRxbXRaMDQ0VHJTamJIL2gzUi92djIrZFE2S21PVnhJYytrWDhzZ25T?=
 =?utf-8?B?SkVFQnJCblg1ZFREWitIUG9LU1NkNWw4aHNWOW1NUW1Hd0hacnVzOVgyL1RM?=
 =?utf-8?B?NEVaMWFSTjhMRGlIQ0NZODkvYVNJQWVTdGZ3bURYQlY5R1NZL0g5OXVHaGR3?=
 =?utf-8?B?VHpYRHpqK2t4Ym1hRWNLb1BMQXdaWFB3ZTZxOGpIZTRhbjRNaUkzdWx2dndI?=
 =?utf-8?B?NEFVY0o2YlpVTklXN2g5dGpFMWZWd01rcHZ0UXhZSEhhR3IyWW5VdXJQS05h?=
 =?utf-8?B?aHhMZ2ttUlJGQ0EvUFVkcHRpK216Zk05WERtdE5RK3Z3Z2xqTktGekJ5Nm05?=
 =?utf-8?B?MURFbUVrTDBDeXVFYW9YWHplMEt5a3Z3MmFRMEpxbHUvL1lEUDMrdTk1cUVs?=
 =?utf-8?B?dmYwdTNUUXFYbzRMSTR2VFpwN3k3U0tjaCtCekpVTEw5Z0Q1cDlVMGplM2s4?=
 =?utf-8?B?VnBEMDZXTysxYnV6RmpaeThpcWVlOUhNRkZLelFqeE1jOUFuTmpIOVJuckhk?=
 =?utf-8?B?MU5UOWgxY1dYczMrVllKZFdiVWIvOTEzaGM4NGhGQUxsYmRwM1ZpbDFwVTJE?=
 =?utf-8?B?SmYwVjR6N1BYY2x4dE16Z2ZvRE03bk91K201d1kzdnViYjdlcFA2cThzTEVp?=
 =?utf-8?B?ZXBha0hvOVBBUnBZcFVzbDgyLzFlQjZDT1N4YTA3dmhXdUlvMXBFdWJDMm9Z?=
 =?utf-8?B?ZHhxZnowbDFXUW02d3VVeFA2WURURVNCbk1oZ1czZ084dE52S2Q0TXI4cVQx?=
 =?utf-8?B?dWVtRDlqQ1FaUGpwNWVFTDFZU0NvNCt0cjlpWC9hb1VJNzVZb08ydzZrZWFh?=
 =?utf-8?B?Ty9jWnlrbkhDT2hLcVcvM3VscTE5ZUU1UFBXSWVsU1Bsb0NIblRVeXRhQTFQ?=
 =?utf-8?B?RU9NbUxRNnpCNnhkRjcydz09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48c3b21e-11c4-4ce3-ad7f-08d8e58adf85
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2021 19:13:09.2741
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WjqXfElZVNnWreLZaG4Q6qXJnBvRamk/u/81zSvrkt//h1UmHF0+bUoz2bQ3O0qXagKFjxs9CZscZ6xwVn5EUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3687
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9921 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 adultscore=0 phishscore=0 mlxlogscore=999 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103120142
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9921 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 lowpriorityscore=0
 impostorscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0 adultscore=0
 phishscore=0 spamscore=0 priorityscore=1501 bulkscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103120142
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

On 3/6/21 5:56 AM, Paolo Bonzini wrote:
> On 05/03/21 23:57, Dongli Zhang wrote:
>> The new per-cpu stat 'nested_run' is introduced in order to track if L1 VM
>> is running or used to run L2 VM.
>>
>> An example of the usage of 'nested_run' is to help the host administrator
>> to easily track if any L1 VM is used to run L2 VM. Suppose there is issue
>> that may happen with nested virtualization, the administrator will be able
>> to easily narrow down and confirm if the issue is due to nested
>> virtualization via 'nested_run'. For example, whether the fix like
>> commit 88dddc11a8d6 ("KVM: nVMX: do not use dangling shadow VMCS after
>> guest reset") is required.
>>
>> Cc: Joe Jin <joe.jin@oracle.com>
>> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
...
> 
> Queued, thanks.
> 
> Paolo
>

While testing the most recent kvm tree, I did not find this patch queued
(debugfs entry for nested_run not available). Would you mind help confirm?

Thank you very much!

Dongli Zhang

