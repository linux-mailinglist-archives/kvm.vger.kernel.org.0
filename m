Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7AC625E74
	for <lists+kvm@lfdr.de>; Fri, 11 Nov 2022 16:35:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233716AbiKKPfg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Nov 2022 10:35:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233679AbiKKPfc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Nov 2022 10:35:32 -0500
X-Greylist: delayed 62 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 11 Nov 2022 07:35:30 PST
Received: from esa3.hc3370-68.iphmx.com (esa3.hc3370-68.iphmx.com [216.71.145.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C18163BA3
        for <kvm@vger.kernel.org>; Fri, 11 Nov 2022 07:35:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1668180930;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=tAtlsusJi2Uehnp+gIp0x/mg5H8s7s0QemxFHGuOce8=;
  b=btl3d2BEREIKQ5e6ibgB/iRbsrOPj1BD7Lt1a/6GSMN8Dnp8pXKlDzP1
   4bX8QOwwnqA0q+6oKOBXfa364aGtp+0iXavqRntvok41xhCHc45+5WvY5
   9AlamHr7pYejYIy3nErLLLHl+1MK2FpoU81JNMLHqZLCVOSmCiOZPbIxZ
   U=;
X-IronPort-RemoteIP: 104.47.56.40
X-IronPort-MID: 84652039
X-IronPort-Reputation: None
X-IronPort-Listener: OutboundMail
X-IronPort-SenderGroup: RELAY_O365
X-IronPort-MailFlowPolicy: $RELAYED
IronPort-Data: A9a23:dtVhLam0kYEQYpLHpjTpY2Ho5gwrJ0RdPkR7XQ2eYbSJt1+Wr1Gzt
 xIaWzjQMvyKN2r3co9/OYy+oUoF65PTzdA1HlRuqyE0RiMWpZLJC+rCIxarNUt+DCFhoGFPt
 JxCN4aafKjYaleG+39B55C49SEUOZmgH+a6U6icf3grHmeIcQ954Tp7gek1n4V0ttawBgKJq
 LvartbWfVSowFaYCEpNg064gE4p7aqaVA8w5ARkP6kS5QaGzhH5MbpETU2PByqgKmVrNrbSq
 9brlNmR4m7f9hExPdKp+p6TnpoiG+O60aCm0xK6aoD66vRwjnVaPpUTbZLwXXx/mTSR9+2d/
 f0W3XCGpaXFCYWX8AgVe0Ew/yiTpsSq8pefSZS0mZT7I0Er7xIAahihZa07FdRwxwp5PY1B3
 dElMTYwbQmDvM633ryHcuRg3uY+EPC+aevzulk4pd3YJdAPZMiZBonvvppf1jp2gd1SF/HDY
 cZfcSBocBnLfxxIPBEQFY46m+CrwHL4dlW0qnrM/fZxvzeVkVI3jOCF3Nn9I7RmQe18mEqCq
 32A1GP+GhwAb/SUyCaf82LqjejK9c/+cNJOSuDirqU76LGV7kw2N0w3aAvimuCGtW29Q9V7M
 E0t4QN7+MDe82TuFLERRSaQvn2ZrBgRR8F4CeA26AiRjKHT5m6xCWwFQjNbQNMhs8AySHoh0
 Vrht8vkGTF1opWUT3yH/7uZpD/0PjIaRUcBeyosUwQI+Z/grZs1gxaJScxseIalg9uwFTzuz
 jSiqCklm65VncMNz7+8/13Mn3SrvJehZhY/4QPFX2Skxhl0aI6se8qj7l2zxelJKp6USFaFv
 VAYls6V4eYSS5qKkUSlQuoXG6qyz+2YKzCaillqd7E67TWz8mK4dKhb+zh/IAFsM9pCdDP0C
 HI/oitU7Z5XeXevNql+ZtrrD9xwlfS4U9P4SvrTc9xCJIBrcxOK9z1vYkjW2H3xlE8rkuc0P
 pLznduQMEv2wJ9PlFKeL9rxG5dwrszi7Qs/nazG8ik=
IronPort-HdrOrdr: A9a23:XUzji6Ae9//M07HlHeiEsseALOsnbusQ8zAXPh9KJCC9I/bzqy
 nxpp8mPEfP+U0ssHFJo6HiBEEZKUmsuKKdkrNhR4tKOzOW9FdATbsSp7cKpgeNJ8SQzJ876U
 4NSclD4ZjLfCBHZKXBkUaF+rQbsb+6GcmT7I+woUuFDzsaEp2IhD0JaDpzZ3cGIDWucqBJca
 Z0iPAmmxOQPVAsKuirDHgMWObO4/XNiZLdeBYDQzI39QWUijusybjiVzyVxA0XXT9jyaortT
 GtqX252oyT99WAjjPM3W7a6Jpb3PPn19t4HcSJzuQFNzn2jQ6sRYJ5H5mPpio8ru2D4Esj1P
 PMvxAjFcJu7G65RBD6nTLdny3blBo+4X7rzlGVxVH5p9bieT48A81dwapEbxrw8SMbzZJB+Z
 MO+1jcm4tcDBvGkii4zcPPTQtWmk29pmdnufIPjkZYTZAVZNZq3M4iFQJuYdI99RDBmcca+d
 pVfYfhDTFtAAqnhkXizy1SKRqXLywO91m9MxM/U4euokVrdThCvjclLYok7zc9HdsGOud5D6
 6vCNUWqJheCsARdq5zH+EHXI++DXHMWwvFNCaILU3gD7xvAQOFl3fb2sRD2AiRQu1/8LIi3J
 DaFF9Iv287fEzjTcWIwZ1Q6xjIBGGwRy7kxM1S74Vw/uSUfsuhDQSTDFQ118ewqfQWBcPWH/
 61JZJNGvfmaW/jA5xA0QHyU4RbbXMeTMoWsNAmXE/mmLOCFqT68ujANPrDLrvkFjgpHmv5H3
 sYRTD2YN5N60i6M0WI9CQ5m0mdD3AX0agAY5QypdJjubTlHrc8wjQ9mBC++tyBLyFEv+g/YF
 Z+SYmX4J+GmQ==
X-IronPort-AV: E=Sophos;i="5.96,156,1665460800"; 
   d="scan'208";a="84652039"
Received: from mail-dm3nam02lp2040.outbound.protection.outlook.com (HELO NAM02-DM3-obe.outbound.protection.outlook.com) ([104.47.56.40])
  by ob1.hc3370-68.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 11 Nov 2022 10:34:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gOL3gS31xHqeqiQQztyC+11RSEf4JtkvyWC8A2kyglcJ01JOZAFfRrDH8pmZW+w/ywE7RkGIFfHqt+gFaKTCHOaABk48J5gvbGyqXM3ByZ1tcV8aRW6n1FhnLHJvrBGUmPQdn4u2R5wxxa5O8zJ49KhnvWhUkh74+PxZLNhyO2HP+JgXJKdEmRBFXnMtBtCiINVGIWZNcEaTbjWv7BOFgMermKxOxJypSE5pDeqaEpdoEXCqddTGjUWD67OkLaoGhV+47HKzUvqLeeAWZ8FtFJvctGsZq4Wo3QBTz0xTKcq5Dr5x8fsl1iFxR9lme8W/1gtDQgejGK5iMl6D8Xs0VA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tAtlsusJi2Uehnp+gIp0x/mg5H8s7s0QemxFHGuOce8=;
 b=UebEQC39n7jg6/HR5bEEem3mb/xcMrpNR442Vrdytbc4PL5X+SZyqBAMuE4Jf6gf/qP+myx21163GTmRmqQnkwDURfezr07hWYBcuvqqwvnVXAq1L8Dj5ezYh99HfbYUsb/HBSuISdZs4RJEl7lIroGOb/dHeetAKRGSMmamLNlUWhAMbPOvGVtmHnNDWj0xYxew1dI2L8zWF5VY9D0WFI4QOqarqmGc6P18QDugACozmSQYsscwJxrU5LAeyn9ocrqct1EehTyihO2fBeSalpG9Z3k4M9R52/rTzDw0rpoanFqo3R9omot/Hff7RR/xIQ8QiqjGAWkp4luCa1wlNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=citrix.com; dmarc=pass action=none header.from=citrix.com;
 dkim=pass header.d=citrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=citrix.onmicrosoft.com; s=selector2-citrix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tAtlsusJi2Uehnp+gIp0x/mg5H8s7s0QemxFHGuOce8=;
 b=gQP7+/pLOPNaM/BtNOvaGpDaQcTwewDQU+lzjbSM1qS37GU2kMbPG4wfsM5BsZp538avyUdh2SBl2ASOp1uN1mpIGg5h3CuCyX3WC51o9Xu+53aUd7xynlPavX52hOiv3+UGalNplK6Wp23kF/t2HXVCgoDWexJjwr3MqwD5R8o=
Received: from BYAPR03MB3623.namprd03.prod.outlook.com (2603:10b6:a02:aa::12)
 by MW4PR03MB6587.namprd03.prod.outlook.com (2603:10b6:303:12a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Fri, 11 Nov
 2022 15:34:23 +0000
Received: from BYAPR03MB3623.namprd03.prod.outlook.com
 ([fe80::1328:69bd:efac:4d44]) by BYAPR03MB3623.namprd03.prod.outlook.com
 ([fe80::1328:69bd:efac:4d44%3]) with mapi id 15.20.5813.013; Fri, 11 Nov 2022
 15:34:23 +0000
From:   Andrew Cooper <Andrew.Cooper3@citrix.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Alexander Potapenko <glider@google.com>
CC:     Peter Zijlstra <peterz@infradead.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Juergen Gross <jgross@suse.com>,
        "srivatsa@csail.mit.edu" <srivatsa@csail.mit.edu>
Subject: Re: Making KMSAN compatible with paravirtualization
Thread-Topic: Making KMSAN compatible with paravirtualization
Thread-Index: AQHY9eFcHH1JYMsgREmwx+zG/XY6ba452mKA
Date:   Fri, 11 Nov 2022 15:34:23 +0000
Message-ID: <2a8fb798-7680-8b9c-7aef-f267eae98f4d@citrix.com>
References: <CAG_fn=W0vXvFrQdRhZiCriz7JjM+zLzKQY+z36j+UqPYnsmq_Q@mail.gmail.com>
 <875yflo6th.fsf@ovpn-194-83.brq.redhat.com>
In-Reply-To: <875yflo6th.fsf@ovpn-194-83.brq.redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=citrix.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR03MB3623:EE_|MW4PR03MB6587:EE_
x-ms-office365-filtering-correlation-id: 33ca7de7-0321-43ff-9a21-08dac3fa359a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: =?utf-8?B?aGRTcVVlanlWNE5SdEFSTHIvTFNIN0tWVFV1V2ZwVUVVaDRlb2huaXB3Umpx?=
 =?utf-8?B?ZXEyZUkwVW03UWhXYnU4YjNJUlVGRFVneEI2OTBJWHNPQWpHM0lsNkZ2dmxD?=
 =?utf-8?B?TmovM1lRTnI2SHpIQTFJd2pMZkJyZi9xWXMwcTZRcTJUS3RucW8wZWJTRmtv?=
 =?utf-8?B?VkpLcTZFMCtkdnFsWnFMTXA2Q0Fkdm91N3ZpNzNOUXEwOWNJZEhydVpBQVVw?=
 =?utf-8?B?YjBDN3NSUjFnUzJoUzNqOU9OV0s4TWpVbXh0ZU5ScDlUdENlRGRTQnJjVVBx?=
 =?utf-8?B?c2RLUmxudXZpYkp4K0VvcnM2aFlwd0EvZFg2blM5NVJOSXJ2MUhaSVBZVkY4?=
 =?utf-8?B?N2hsdFdEcVJBbmZ1K0hqVWk5bEZ2WkZNaElZY0F1TThVZi8vb0pQUlY1SU9n?=
 =?utf-8?B?d25qN0FBK3JGVHlGMk5rcmN3MjdkRWQ5T05UYW1rWUhFcVpielVPbGx6SDNT?=
 =?utf-8?B?TTExY0R5K2JiOU94aFg5NERpR3hycnYvUEg3Yjd5ckFxS05IakZkTWo5VDcz?=
 =?utf-8?B?Um9Kb042NVIwdlZCeHU4ZU4xZnFhbFBxa2FoSExjbWlSWHlVU3FtUnJEdlJR?=
 =?utf-8?B?WXIwOWlYSzVsSlkzK1Y3MFRsb2JsbnhpWFo3Z0tzbFg3ZU10NHNCUU1kNkFG?=
 =?utf-8?B?ME5BNURnVGZmc1Fta3VBc3orZ2hLSFdXTXlwK1RBQ3VLZCtKTEhqTEZ3TGFa?=
 =?utf-8?B?MnZrVE9YcFc4L2xTVVNQSFk0bnluMGZ0NWZsWEI5bjduaFlDZExWakRpQTRu?=
 =?utf-8?B?MDhZMW9XaXZQcW4xc1J1UE9ZVmVuelRBZmViZXd0K3RQUHhKZG90bWg1dzYr?=
 =?utf-8?B?VXBWZERHNmVienNGOHRjZ3JSZHhkSUhZcmZuNkY1TEZ1UERKVlBETUNDbW41?=
 =?utf-8?B?OStFRW5OS1V6ZGFPZWd2Rkg0SjFwMmFTTjU4dGwreitpdFMvbGk5Nk5IaDF1?=
 =?utf-8?B?YUx4VUNDT2ZDa1A0RmtXQll2SWQ1cmx0eDg5d3V3UGZyR0Q3NElVT0VOanJI?=
 =?utf-8?B?ME4raVoybmxnaCtJWTdFQVpqZ2JGZ0dFSTJlNC9mWGdYNFU2Y3V6Ti8zUWhC?=
 =?utf-8?B?SFVxL0Ivb0dVTVNTWmRQcHBCUXRNL3NpVEV6UzFqQk5iRjNMTDI2U3BSYWpn?=
 =?utf-8?B?RFp4ZGVFMUdLcnBudVBvMjhLWERDcnhYakFDZmZtakUrbHI0NUNIRnUwSGVM?=
 =?utf-8?B?N3VRMm9HSHdZWG8yWW9wWmJzSW5hVUdaZ2ZVN2F3RnBhc1crdUtVQ3VRdFJV?=
 =?utf-8?B?WU1SNU8zYWREbzdxWkdoaEUydEhzT2ZzUlh4VnJrMnJLT3hkUT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR03MB3623.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(39860400002)(346002)(366004)(396003)(451199015)(36756003)(86362001)(31686004)(82960400001)(31696002)(38070700005)(54906003)(83380400001)(122000001)(26005)(6512007)(2906002)(6506007)(53546011)(2616005)(38100700002)(186003)(66446008)(66946007)(66476007)(66556008)(478600001)(64756008)(110136005)(6486002)(5660300002)(8676002)(4326008)(91956017)(316002)(76116006)(71200400001)(8936002)(41300700001)(966005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Sis1TnpWVzlUZ0ZWNmhYVVF1Y1ZvYm5UQ2N5MTRBMWNqWGtxejRnMytTVHNK?=
 =?utf-8?B?NllCS1NhblR3cDRqcGd2RHpjWDViSEhZK1lFZlRUdkJmYnp0L0RnZ1FDd3Vj?=
 =?utf-8?B?YU9jWmU0ZVBtMXFTTmpNZ1JBeEJoTVNWVzRCL3YwREIvRDBDY3RBQ2dRTlRv?=
 =?utf-8?B?REFwT1MvM3RUNWRQNERFNUdFY0ZYaU9wUjB3YXRwa1pVZmxrQ3ZnOElRWDZS?=
 =?utf-8?B?LzZJWkg3VlRpQU9hb0ZwVEt2QjJhdjV0Y0hvZmJJSC9UQjFKSjlQc0hzRGsw?=
 =?utf-8?B?dVVmTVVJSnVBcVBSdldGQkNySmRCSFdMUjdaSmtCOENPS3g5QlYwdjJGVUg5?=
 =?utf-8?B?U1NMY01NY09jUTA5V0FDTm5USUE1dWdCSWxQakgvYlplbVJtTk1hSGNXajli?=
 =?utf-8?B?THdVSXladzFOTUh5MEZGb2oxUVZONm5hTlo4WVpCYmxYSytRQmlPU2d3RVM5?=
 =?utf-8?B?TTlCNFdjL25kTFd2UDFRb0xLM3RpcjUzWmIrQ1poTjVYbm1sZEpDbUFpNi9z?=
 =?utf-8?B?NlM1ZENweGtkTU9nek96MjhnUnNKYzArTjZJaDZzb0JiMFphc0pJN1pxS3hC?=
 =?utf-8?B?NGJScDJNYWgvd0V5QTJTVEFIVmY0RG9aWTZkVkdSZHlxYXBJNnM0STlUbmpT?=
 =?utf-8?B?Y04zTkdsKzlTaThxRHlFOGpLUENFRDEvSVNTU0t5RWNGVkVoMCtRYVFvanJQ?=
 =?utf-8?B?N3Y2NTlLMmw3dk9rUWh0bUxuaU5ObEs0SmFnOWxmRWVZU3cwZGJyR3lxQkpK?=
 =?utf-8?B?WTA0bE01T0NRZmR6em94RXpDME9HbVV1QnpzalRnSkpYS2JSbXpkc3NFbUZR?=
 =?utf-8?B?T1d6YjY0OWN2OGQ3WFNYQXpYSzFTZ2IybUJ5YkhJQXRmSjgwVFZidk80ZVVW?=
 =?utf-8?B?MlowSWtqalNPTy9JaEdRRnZscGRGTzRWRmVVVGJpMkRHZUFnRnJWcDZ1MFVT?=
 =?utf-8?B?eDdVL0JMOXpCRWZ1blNwZ1VIdDJxWkVISUdFNi9kdHhMd1RoMi9ISXJKUmha?=
 =?utf-8?B?SDFpKzlobDNWQk9MbTlkV3g1ZGNMRkpqUEdYeGdOOFd3YnRFdzMwVDR4Nlpm?=
 =?utf-8?B?ZVBvNFQzVHg3NlIxd3JSeUJzaS81NHg0WmVmb3hpN0N1UUJqS3R6cEVNRzJj?=
 =?utf-8?B?NnFlQnVuOS9tdE56d2FnTXMzQnBCc0JiWDFzeGM3Tm9yYkVZOTA0WkVMblVw?=
 =?utf-8?B?YkpudGhFalBCSktBVFpFcEtsNTdRekpTS3RZSVdjdUIxNzYrQ3p4b3FzRk9Z?=
 =?utf-8?B?d2ZvSUFKTWFFaGY5VkkwdWpUZXllSXZuWWRHQWlsVkdBeHVHS1dKZkZQSk5v?=
 =?utf-8?B?U05Ic2VyTXBRakNqRnVHejVtd0s3OXFVVklRY1dneTZEU24yaC9tWlFQVlYv?=
 =?utf-8?B?bkZPL0Rpc3h1cFhXSFJsUGVKL05BRkVuMmZsSHcvbkVCZm1VUE5tOUlzeUxz?=
 =?utf-8?B?ck90U1E5ejA2ZWNtbUEvQmFuUkNJOU55WVEwelhUZ3pSd2ZMUjhHOTF6NU9t?=
 =?utf-8?B?ejhpSlB0T1pRS3JXdEhVVEdLL0tPb2h5am9GV3FFRlQ3WU10L1l6T3MxYVBw?=
 =?utf-8?B?anAzN21tc09UdWw1a1UwMmpYTzl1dmxOaWg4eFU0Tk9WaUpmNFZlMHVnQXRB?=
 =?utf-8?B?YUZiNURldVFjd2dPWm9UZitGbnRYY1NQeExxVUVWRXp6cWYvN3AreWVPa05M?=
 =?utf-8?B?cVJvcC9tOW5XUzJ0bjNYQXlYSTBaeEs2Si91Y1BMTWFQS25WcW50cXRwN1lm?=
 =?utf-8?B?Y2szSFdCenZOWFp3Y3pmL1NOVmVNcFJ0S3ZuZEV4RmExdkZRMUNMblp5bnNo?=
 =?utf-8?B?ZCtRTTNwUzBkRkdLY05oaVhENGRBSWwxMmxhQm5mVlpocWx4ZkRGOWNISWVs?=
 =?utf-8?B?VDdjZ3c5bjd3WWd2Y0VGWEdEQ2xpUk1SZWN5enBKMUFQNUFIa2ViVllzbjhP?=
 =?utf-8?B?aURnQjF6WnRwamJKVWNCK1lLd0xGbW40VXpRYXFIN3NUblgwdW1adjZpR2F5?=
 =?utf-8?B?QkF6elNMZGJUUlJ3azN0djZRSVVoanZydUhkTVBIL2t1UE80L2ZUVitDWjRM?=
 =?utf-8?B?WVIzYzB1SU1KdEYzQ3MxNWh4VzFVMEJoVGlUSzEwaGZXVUJneGdnd3h5WlQ4?=
 =?utf-8?Q?dXlRFq3QHaKJGNOMWfoyu5CqY?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7C7266F3CBADC84FBCCBCEA61F0AC99F@namprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?b2VKcGJBL1lpRlJFN3hXbU9FQ1c2Uy9jSWE3WDRWNjNYcEFOdHRIVG1iTmt2?=
 =?utf-8?B?K0ZLV0Yyd3p2aHBDTjV1K3lTUUlkQjNoNWRtWTMyZmNubGFDbTdtemovWjZB?=
 =?utf-8?B?ak5BY0dHTXB4cXl5a1VzREhDRTJKbWVHWEVGOEpySlMxdjhEenNEVDBHRng4?=
 =?utf-8?B?R3ltUDZZUXEvUHN0MnF3ZE13ZWpNdGM3VnUwakhuSWoydVB3VHVlYkM4cDBr?=
 =?utf-8?B?K1VLWkI2QUY2dlp1bmlhVnF0dGs2dGlvdzNVQ2lEVzJpejNSR0ZjRCs2NlZx?=
 =?utf-8?B?TTNuNGRyemE1dzFQMElwUFdwU1BjTElTd2NWZUNoWk03ZTVVMFBRdVBCejdV?=
 =?utf-8?B?ZnBvK3hmeHIvN0liMWZmSGFuMWwyQ2ZlM1VqeTVXT0JpdFpHTXRiaFVIR2Rs?=
 =?utf-8?B?dGtZOFpmZlVSam5nMFpMcDdUTzdCUkgvclczSGVaaGdHWTJkZk8xcTJBUGpr?=
 =?utf-8?B?OTZBc3l0T3VBRFg4U204Y1pzdmNqUFRsUjYwelJIdmtKb2dsUEFHUFpTVkJj?=
 =?utf-8?B?ZnErM1FxcWgyZk1vVE9IQlJZQUxXTFJJaEorQ2JPYkhWWWpJOVlYYVZ3R21S?=
 =?utf-8?B?REZTRTYxVUxzSVZKakZkN1liaDlzKzZ0cUU1QzF1bjhIUHdHelQ3Mk90L2V3?=
 =?utf-8?B?bUJvSU5wa0x1elFxdkgveFBhLzhqd0FuQ0xUR2xyYit5L2xqbGhJWXIvdHk5?=
 =?utf-8?B?Z3ZhbVZtc1NLbmUwckZkSTVRUll4RGdBUmdFT1RSSUw2cHEvTlFCUE1MMGh1?=
 =?utf-8?B?dTNFMFFsaHNzYTZSL2p5Ri9XUXZnK3NDN0NPeFVkUlJIUFhleUsySnVtRWdR?=
 =?utf-8?B?WXhSM0tHeitQVlFBd0ljcTNqM21kYmxQMjhTNzFINlVUMmY5S094VEpVN2lw?=
 =?utf-8?B?R0RCQ0pQWUVRL0xrTlVVNVVNdnkxUTlUOEErc204Mldna3N3V01QNVZPZnd0?=
 =?utf-8?B?VG1ES2p4dzYwT28xN1p0Q05laFNISkpFOHdYOStPc1ZnbUsvT285SFZoSE1T?=
 =?utf-8?B?dlZ0WjdJVXRCUWdiWEVIWlM3NU41TXNLaVdYcy9seXd1ZW82UnpyUzd0TnFK?=
 =?utf-8?B?VDFla1NTVHZqRVl1dTRReHRKeGZzbklQSmEvb29wYmZWSk02U21rMERwckd3?=
 =?utf-8?B?UU1CZ0Y4eHB2dDhaNmYwc1JSRG9pa3FIcXRkekhaV1M0SHpraTZ3blpPODVx?=
 =?utf-8?B?dGx4aGZMbE5GZktPUkV6YU5HN1ZJQkYxMHZFaW9iU3lOYzk3RFRHSG9vSU1L?=
 =?utf-8?B?WE5rd28xZVJDYnJtT0VITWVKOWlBUmZtaWpCV29SdXZMM3FqRHA5bGZCdE03?=
 =?utf-8?B?SkNXZ21qbE4rTWZDOHBPSkc1V3pPcXJIY3pBRnhmSnVvTnFlcW9FYjM5ZSs4?=
 =?utf-8?Q?ZfkLue8BBDHWEpzcre0qls60YV+b4PNQ=3D?=
X-OriginatorOrg: citrix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR03MB3623.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33ca7de7-0321-43ff-9a21-08dac3fa359a
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2022 15:34:23.4442
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 335836de-42ef-43a2-b145-348c2ee9ca5b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: t2G1tv4slj4FDUVcNIhOW9Y1JqSU3r/TA1rcYjnkB/9djFm0uoXPQeVT6OwdmvDZ39SSiPtLnkqnwvu0DwOHfPc0dzf05YBI+P0uUohUos8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR03MB6587
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gMTEvMTEvMjAyMiAxNToyMSwgVml0YWx5IEt1em5ldHNvdiB3cm90ZToNCj4gQWxleGFuZGVy
IFBvdGFwZW5rbyA8Z2xpZGVyQGdvb2dsZS5jb20+IHdyaXRlczoNCj4NCj4+IEhpLA0KPj4NCj4+
IFdoaWxlIGludmVzdGlnYXRpbmcgS01TQU4ncyBpbmNvbXBhdGliaWxpdGllcyB3aXRoIHRoZSBk
ZWZhdWx0IFVidW50dQ0KPj4gY29uZmlnIChodHRwczovL2dpdGh1Yi5jb20vZ29vZ2xlL2ttc2Fu
L2lzc3Vlcy84OSNpc3N1ZWNvbW1lbnQtMTMxMDcwMjk0OSksDQo+PiBJIGZpZ3VyZWQgb3V0IHRo
YXQgYSBrZXJuZWwgd29uJ3QgYm9vdCB3aXRoIGJvdGggQ09ORklHX0tNU0FOPXkgYW5kDQo+PiBD
T05GSUdfWEVOX1BWPXkuDQo+Pg0KPj4gSW4gcGFydGljdWxhciwgaXQgbWF5IGNyYXNoIGluIGxv
YWRfcGVyY3B1X3NlZ21lbnQoKToNCj4+DQo+PiAgICAgICAgIF9fbG9hZHNlZ21lbnRfc2ltcGxl
KGdzLCAwKTsNCj4+ICAgICAgICAgd3Jtc3JsKE1TUl9HU19CQVNFLCBjcHVfa2VybmVsbW9kZV9n
c19iYXNlKGNwdSkpOw0KPj4NCj4+IEhlcmUgdGhlIHZhbHVlIG9mICVncyBiZXR3ZWVuIF9fbG9h
ZHNlZ21lbnRfc2ltcGxlKCkgYW5kIHdybXNybCgpIGlzDQo+PiB6ZXJvLCBzbyB3aGVuIEtNU0FO
J3MgX19tc2FuX2dldF9jb250ZXh0X3N0YXRlKCkgaW5zdHJ1bWVudGF0aW9uDQo+PiBmdW5jdGlv
biBpcyBjYWxsZWQgYmVmb3JlIHRoZSBhY3R1YWwgV1JNU1IgaW5zdHJ1Y3Rpb24gaXMgcGVyZm9y
bWVkLA0KPj4gaXQgd2lsbCBhdHRlbXB0IHRvIGFjY2VzcyBwZXJjcHUgZGF0YSBhbmQgY3Jhc2gu
DQo+Pg0KPj4gVW5sZXNzIGluc3RydWN0ZWQgb3RoZXJ3aXNlIChieSBub2luc3RyIG9yIF9fbm9f
c2FuaXRpemVfbWVtb3J5IG9uIHRoZQ0KPj4gc291cmNlIGxldmVsLCBvciBieSBLTVNBTl9TQU5J
VElaRSA6PSBuIG9uIHRoZSBNYWtlZmlsZSBsZXZlbCksIEtNU0FODQo+PiBpbnNlcnRzIGluc3Ry
dW1lbnRhdGlvbiBhdCBmdW5jdGlvbiBwcm9sb2d1ZSBmb3IgZXZlcnkgbm9uLWlubGluZWQNCj4+
IGZ1bmN0aW9uLCBpbmNsdWRpbmcgbmF0aXZlX3dyaXRlX21zcigpLg0KPj4NCj4+IE1hcmtpbmcg
bmF0aXZlX3dyaXRlX21zcigpIG5vaW5zdHIgYWN0dWFsbHkgbWFrZXMgdGhlIGtlcm5lbCBib290
IGZvcg0KPj4gbWUsIGJ1dCBJIGFtIG5vdCBzdXJlIGlmIHRoaXMgaXMgZW5vdWdoLiBJbiBmYWN0
IHdlJ2xsIG5lZWQgdG8gZml4DQo+PiBldmVyeSBzaXR1YXRpb24gaW4gd2hpY2ggaW5zdHJ1bWVu
dGF0aW9uIGNvZGUgbWF5IGJlIGNhbGxlZCB3aXRoDQo+PiBpbnZhbGlkICVncyB2YWx1ZS4gRG8g
eW91IHRoaW5rIHRoaXMgaXMgZmVhc2libGU/IE92ZXJhbGwsIHNob3VsZCB3ZQ0KPj4gY2FyZSBh
Ym91dCBLTVNBTiB3b3JraW5nIHdpdGggcGFyYXZpcnR1YWxpemF0aW9uPw0KPiBJIHRoaW5rIFhF
TiBQViBpcyByZWFsbHkgc3BlY2lhbCwgbGV0J3MgQ2M6IHhlbi1kZXZlbEAgZmlyc3QuDQoNClhl
biBQViBoYXMgc29tZSBzb21lIHF1aXJrcywgYnV0IGl0J3MgcmVhbGx5IG5vdCBhcyBzcGVjaWFs
IGFzIG1vc3QNCnBlb3BsZSB0aGluay7CoCBDZXJ0YWlubHkgbm90IHJlbGV2YW50IGhlcmUuDQoN
Ckl0J3MgYWN0dWFsbHkgbG9hZF9wZXJjcHVfc2VnbWVudCgpIHdoaWNoIGlzIGJyb2tlbiBoZXJl
LCBhbmQgd2FzIGZpeGVkDQppbiB0aGUgY2FsbCBkZXB0aCB0cmFja2luZyBzZXJpZXMuDQoNCmh0
dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xrbWwvMTY2NjAxODQ3MTEzLjQwMS4xMzYxNjgxMDU5MzUx
MzM2Nzg5My50aXAtYm90MkB0aXAtYm90Mi8NCg0KfkFuZHJldw0K
