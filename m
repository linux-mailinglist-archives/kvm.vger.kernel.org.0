Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BC8D4B0D6B
	for <lists+kvm@lfdr.de>; Thu, 10 Feb 2022 13:17:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241491AbiBJMRv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Feb 2022 07:17:51 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232947AbiBJMRu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Feb 2022 07:17:50 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B29C281;
        Thu, 10 Feb 2022 04:17:51 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21AAflnR017470;
        Thu, 10 Feb 2022 12:17:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=5YcRJfGkBH4rizvB/yZqVaVrHOkP4Fpt+VzrsYU+4gw=;
 b=BzkwSrwhWAff3yTubooFxEA0EmxcKXpEXsysk8k2RrLyaQaGfpaI5xLyo6wvnsLSvTbS
 lRVpU0j8szaLgVzNsqBJ+heGuaBmypPDevvRO+WNZ/5sN26SNfIcu+3yfvi88JmFbPeT
 E7o0hlAMq3pMjI6sC6SLt9q0Ahls5jnwdI+S1dsoDtxmXY2PwwZxK0h86SVGst4QvNcP
 jWskNdjHQ1V7BQTMYNhfwC0yDe7NVK/sFFuhFrEvICRJnEFMCCSP8iC7OGcXcey9AsXQ
 ue6XL8whQFvmhK4kularssOPR66xw5LyoXTOz0C7OHoHLFBSnysB7VmZkjAnGYTCxPRR zw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e3h28qrqm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Feb 2022 12:17:25 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21ACGp3v167374;
        Thu, 10 Feb 2022 12:17:24 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2172.outbound.protection.outlook.com [104.47.58.172])
        by userp3020.oracle.com with ESMTP id 3e1jpv4q7e-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Feb 2022 12:17:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jwk5DIQ0++UsgGXpeucuXRMk40mzkFGDsLp6oLTds+qjQjfYPIoonU6kpYg/lWxPH0LpQtwW+ZLnhCS9dHrrVnraK2S/ziJC5xy6ZtHNzD5JxqxkCGGdcLUPqDE5MuW0+fnW6pM6LzcwcO83tyNPg4WUTeoR8UF//1VZy+7x4gA0q153BfWfrq9nJrZaCfPz3/OjiiSzeiqgM2rFhxDE8m9F5GVbauVLy1cljS0R4jGbeyhsHIiS2aUQBhhG/HIAYo3tFmmhM7NRlKJVze7hZVy85ILBmaVlSowpF4cEVmqJ+D1FsSd2kGKhHkKJ1vzm9I26RfOkZ60Ov5ogsEmcxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5YcRJfGkBH4rizvB/yZqVaVrHOkP4Fpt+VzrsYU+4gw=;
 b=dkphX2mnWLjFCoV3jcXhY7+hTXJKBqRlagUsu6+bbhIcgtWDbkWdwJRCEu7Pgzy5sBh+vSvMXS1c/bDebhbHdMUBbzx4jC8wuTesJxNbpOjMv0YMzv6VBQ/RqNmXqEg4dRepYgOGf983OxHY2ikIxRJZG1yz41Y9yjLs0JfAAX4le8Ek/Sh6fpgf2+Q/VBbWV9Deo9tfTemjJjSQTH3/ORFh/UxKcuwMOriWKzzRjdPVowJksNXEs29QLOpEqqgGnF4+Zg8YmdEsNYAWTPvBStQNm//coWKJtjKhGbYZldNTROjpY+ebN+ZcoG5HRzbgn+F0Kwh0OQ1cDsAJaWwhyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5YcRJfGkBH4rizvB/yZqVaVrHOkP4Fpt+VzrsYU+4gw=;
 b=i6Cpz7UKRxMQ0RYlnXPVro5Ceqhz2J4pI57q+uFYpE3jdv7FzXldmKb5mOm1F4iZrJvZFpvdvRmYI7/Zp/wPgKspdznr+EfGVBiQpffQ1Y105+68DiXwVdWQzdNlWMu7AES/a26n/A3NePgHOZ/1/Sn3fB9BRd0/nAjF834DYfE=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by DM6PR10MB2651.namprd10.prod.outlook.com (2603:10b6:5:b9::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Thu, 10 Feb
 2022 12:17:22 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::4910:964a:4156:242a]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::4910:964a:4156:242a%5]) with mapi id 15.20.4975.011; Thu, 10 Feb 2022
 12:17:22 +0000
Message-ID: <97bdf580-c1ff-0f2e-989c-da73a2115e7b@oracle.com>
Date:   Thu, 10 Feb 2022 12:17:14 +0000
Subject: Re: [PATCH RFC 12/39] KVM: x86/xen: store virq when assigning evtchn
Content-Language: en-US
To:     "Woodhouse, David" <dwmw@amazon.co.uk>
Cc:     "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
        "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "ankur.a.arora@oracle.com" <ankur.a.arora@oracle.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20190220201609.28290-1-joao.m.martins@oracle.com>
 <20190220201609.28290-13-joao.m.martins@oracle.com>
 <b750291466f3c89e0a393e48079c087704b217a5.camel@amazon.co.uk>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <b750291466f3c89e0a393e48079c087704b217a5.camel@amazon.co.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LNXP265CA0069.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5d::33) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7f68d2bc-fdb8-4528-8762-08d9ec8f4a22
X-MS-TrafficTypeDiagnostic: DM6PR10MB2651:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB2651C5B2E3B043CADE692D73BB2F9@DM6PR10MB2651.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h/X9Ikvyqs4kpj5XatYLANxIEa0dMTTtNAekHtrYwfxVzH/rJG2FoVyQRut1OM6qSJ9CsbFNnsVi1oDOLzkwN2em4skZN7VpABlBolvjLlMSoK4U1LVr7R2KYTWbxGWf9/DH28XBUEw90XfxcOpkHDY7nnkBtxALCcQgUm16IR3LoSbaPBh37sHWYrH+HvnYZDuOuVwGBYEZthVlpIc56g17IrGJvUu1ghk8LF3/zUFWPfWMgTnBLc+ddlgIDAxW1Wv2ADCJJM7wcAfBmf2t3RerwLPJpJ8frvUzugrbw8F9f5fYOyBRL7oh4tm5Jfn+1wx70cbZYqWXt60K4Ecg1nDgAaHaXgapKGawDIXhOtFZU5gB4zb1YHDDKNzAgDx14bUjkNcxOCww/Ash42KouC55WV/x66D48knm9U27u3XWUII7BmcYMDnCSm5NaZ1nPAUZSgrV6/a/v0apIySTsbLHEKhAEqla8GEujQ2VVCWDq7At201EJeO54qPso/GDAGD95vf0blpBRHMulTEep426kct/eRNrFJQZPoPZd3Pf9kJv+tsgADtLprrXOySkefklhjfjzBQJO8FILA5VnBhimKAbL2tIfts7lJuugOpAM4/a2NQxwmNPZ0X8/Jy4N9l+3VumHzMD9ZZAViOcImChyYRP3ec24JZSzIggY4BLdD/GWqn79q82Q1dDDwXUuSvH0ngw3HlCdit7f28igER8A/sQOEid2Gg+UrlN/nPw932mmH2B9eYRfshdUEOGqEB19jMLG9vf9kxUCAz9qxcCZ0fofO79Jbei/IiYMeM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2616005)(31686004)(186003)(66946007)(26005)(6512007)(53546011)(6666004)(316002)(66574015)(86362001)(6506007)(2906002)(508600001)(38100700002)(8936002)(966005)(7416002)(6486002)(5660300002)(8676002)(66476007)(54906003)(6916009)(31696002)(4326008)(66556008)(83380400001)(36756003)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QjAyMlFGZ0RaK24rbXJGcFZRZVgzNVNRYXEwc3BJVDV4Q2JxRFZUNkE1ZkhB?=
 =?utf-8?B?Mk1rU0R1cjFQcTJGZTdNQloxMEpoQjNzOSt0c0FkN1BVR3owZEtrZUdNbmhy?=
 =?utf-8?B?TUx5cmxWK2U0TmZOTkUzQmk2b1RBQ3BUZkVOdUI5N0JQNDdEUEVHZkFzRFVv?=
 =?utf-8?B?V1ErSlA4TDdWZm1Dd1FBT2QzV2RnQndTWm4zKzQvdklkUk5EN3h5N25EYzdF?=
 =?utf-8?B?ZTQ4ODBEdXdGZEsyZ0VCOWJGYmJoOGY0T0FKZU9EQkJHSGZ6QzBLSVZzWjBs?=
 =?utf-8?B?N3Z4OHlYTHhKOWtlZktxWGpGMlE0N1hSRUQzakhHenV3S0FkTFlyMlFkZ2tv?=
 =?utf-8?B?cFMxSVNOalQvUzh6M0hQcGtkcWR1Nk9ueC9jRmR0aHhXQnVlS1hvTzVyMStQ?=
 =?utf-8?B?NGxVQjRXOXdvYjV0eHRxNFNBN0VYdmRDZXYyOFdpdCt1SWZVU1czUXhRNk1Q?=
 =?utf-8?B?K3Vhcklpb0I0cldYTjZLTklJVlcxTGVrL05nYmZ0OEwrYWV1dUhOdkV0K2dS?=
 =?utf-8?B?Tjk5WUdKMHhYTk1wR3dXM1duOEp0bmFvVlAxWW4ySmJYcmthNFJQVnYySHow?=
 =?utf-8?B?NEYyQUtydkZpdG91bnduRkNERGxyTTNlY2xPakZEWWs4ZXZMU0dOaWkvMWg5?=
 =?utf-8?B?UGlUZzN0Q2JZZzdORFZMR2Y1Rm9vUDl6ZE03MFhoRjRrYU5NVHIybzdVWVR2?=
 =?utf-8?B?ZHlxdWpITHBjRndaNGZPdkE3aXovOUFiMDdIOGRKaWV1YUhqQ3BDSnM2a0ZL?=
 =?utf-8?B?aVV0MUVJenVFS0dCY2xxbHo0b0VZN05pdk1ya0p4Z3QrVGUxWFZLREJ5bzA1?=
 =?utf-8?B?L3dCMWdmVUVReTBOcnNxbFBTTzZUT3pDZWw1cEtVdWxEKzZiWHlmVTFRcjF5?=
 =?utf-8?B?UXVqY1dBVWxHYTdvRGZpeEE0RHd1WGhKM2NTcjZFV0hROHE2a0hTWjZUcWYr?=
 =?utf-8?B?Zy9FR2Z4LzlmcGZHV1FLOURVaUxHM012ajJweUxkWDY0eUFTeVlWMVZUR1Fu?=
 =?utf-8?B?VDQrZ2tYY3BydUdQNkNVb1pqVmlWREtiZXM5VzAwdkRjYU1LeWRxNURvQVM0?=
 =?utf-8?B?Wnd4dkhSdWFPNWJacHluOGxSeG1yOVdyQ3k3OElTZElCUDZaTDYwTko1anQx?=
 =?utf-8?B?U3RvT1R2Z2ZWQkdFRUdwcjhWaFhRbTlkVHVMN0xDdkhpYm5sSjBTOXRMNm14?=
 =?utf-8?B?NHRWWkFCV3lJMlYwQ0JHMGpRdFZqZThFdDZ6eEtqencwOGFLWHdHVE9YQW1L?=
 =?utf-8?B?Ui9CZ2Rlejd6YmI5cmc2clEwTTJsd3FhalJrSHZNZDR5eGlTNFpwMStiSzEv?=
 =?utf-8?B?Lzducm9sb3g2Wk1TcVFvVmFnSHU1K2RRQzJEamlLY3U1a1BVUUZuVWdtU1dR?=
 =?utf-8?B?UkRRZFJoZmtKdnJlYmtNNlE0T0l2NmRaUWlnWWcwOCtnUm5Da09xSnpKWUx6?=
 =?utf-8?B?SWIxUGFIYmFYS0ZaeDlvMmhUYkJ6Y2t3NFZYRzdicTN1cWFNTWdWeEVmZVVw?=
 =?utf-8?B?aHpJVmgvUVp3NURKU1htblYrS3ZlQzF0SCs5aUlza0UwbG9aQ1hla05uSEgz?=
 =?utf-8?B?UkhaM0FlK0gyUGpUekNZRXVjc2diS293bW1oVDZLa1BsQVdHWmYvMjNOUE0v?=
 =?utf-8?B?UHZjQzhibEswVTAxSlhRU0FFZk9KVjdsc0wvWjEzT2MvdVM0anlTajRVcVh2?=
 =?utf-8?B?R0RDNXpjVW54d09VNlNLQUEwVzdhZ2hiRHFpYUNRM1U1ZXVzc2N3NEtZUEs0?=
 =?utf-8?B?VWJGMyt0K1FsSEEvWTFWOHh0YVNDMEJXK2dHV1VxNTlqK0N1cVR6MUUxWlZx?=
 =?utf-8?B?dDIzcXR6THJFRkI4NnFLMlMvYmpRNDZtaUgwS1BQcUNiL0tJZmpIalVNV2ND?=
 =?utf-8?B?T1lERHhnT2h5NnBRcGk2OVBSVDJrL0hOTTllT28zUXpnLzhDSVZteUFBY1R3?=
 =?utf-8?B?TDlaeTh1OTBvaGhHOC82QWFhbGZlVHZsbXdOYTBLQm9scXZ5ampWc2k4S094?=
 =?utf-8?B?OTc2TWIrcTlOSFlVY3BKamw4bE1xbTE3ZnVxQ1FpV283MTRmU2pVbEtPTGpH?=
 =?utf-8?B?b2JlK0VDd3hvWEJhWWZiMjBhUFo3NHRpQWpwblQ4WFVHK2hQbUl4VG9Sbldk?=
 =?utf-8?B?bVJkait1WThYVWlGVXYwa1FLUStOckE2cjdOOVlKanMza1QwY1hNT3RCVGIy?=
 =?utf-8?B?NHA3eGxvOWtLV3VGVDFKdnV1dW5SMEdnNkJvbnU4QzF3MnZ0QlpINDBwdkE5?=
 =?utf-8?B?d2w1aVlRV2ErOFZPMnVaRm9JVmJRPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f68d2bc-fdb8-4528-8762-08d9ec8f4a22
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2022 12:17:22.0546
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iBy4UoJooi56juSOotMLfdC+Sld0vlEFt5hhrMWjtpKV7/eGZ3K1K9Fd/gaFlfuWyLAOo+u0Vf6qFIk96YUOd2Q5vkWaszIGBdfFKKonpFw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2651
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10253 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 malwarescore=0 suspectscore=0 phishscore=0 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202100067
X-Proofpoint-ORIG-GUID: Z1V5abJm-r6-Zj7fxwpRZRLk0XXsJxHg
X-Proofpoint-GUID: Z1V5abJm-r6-Zj7fxwpRZRLk0XXsJxHg
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/8/22 16:17, Woodhouse, David wrote:
> On Wed, 2019-02-20 at 20:15 +0000, Joao Martins wrote:
>> Enable virq offload to the hypervisor. The primary user for this is
>> the timer virq.
>>
>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> 
> ...
> 
>> @@ -636,8 +654,11 @@ static int kvm_xen_eventfd_assign(struct kvm *kvm, struct idr *port_to_evt,
>>  			GFP_KERNEL);
>>  	mutex_unlock(port_lock);
>>  
>> -	if (ret >= 0)
>> +	if (ret >= 0) {
>> +		if (evtchnfd->type == XEN_EVTCHN_TYPE_VIRQ)
>> +			kvm_xen_set_virq(kvm, evtchnfd);
>>  		return 0;
>> +	}
>>  
>>  	if (ret == -ENOSPC)
>>  		ret = -EEXIST;
>>
> 
> So, I've spent a while vacillating about how best we should do this.
> 
> Since event channels are bidirectional, we essentially have *two*
> number spaces for them.
> 
> We have the inbound events, in the KVM IRQ routing table (which 5.17
> already supports for delivering PIRQs, based on my mangling of your
> earlier patches).
> 
/me nods

> And then we have the *outbound* events, which the guest can invoke with
> the EVTCHNOP_send hypercall. Those are either:
>  • IPI, raising the same port# on the guest
>  • Interdomain looped back to a different port# on the guest
>  • Interdomain triggering an eventfd.
> 
/me nods

I am forgetting why you one do this on Xen:

* Interdomain looped back to a different port# on the guest

> In the last case, that eventfd can be set up with IRQFD for direct
> event channel delivery to a different KVM/Xen guest.
> 
> I've used your implemention, with an idr for the outbound port# space
> intercepting EVTCHNOP_send for known ports and only letting userspace
> see the hypercall if it's for a port# the kernel doesn't know. Looks a
> bit like
> https://git.infradead.org/users/dwmw2/linux.git/commitdiff/b4fbc49218a
> 
> 
> But I *don't* want to do the VIRQ part shown above, "spotting" the VIRQ
> in that outbound port# space and squirreling the information away into
> the kvm_vcpu for when we need to deliver a timer event.
> 
> The VIRQ isn't part of the *outbound* port# space; it isn't a port to
> which a Xen guest can use EVTCHNOP_send to send an event. 

But it is still an event channel which port is unique regardless of port
type/space hence (...)

> If anything,
> it would be part of the *inbound* port# space, in the KVM IRQ routing
> table. So perhaps we could have a similar snippet in
> kvm_xen_setup_evtchn() which spots a VIRQ and says "aha, now I know
> where to deliver timer events for this vCPU".
> 
(...) The thinking at the time was mainly simplicity so our way of saying
'offload the evtchn to KVM' was through the machinery that offloads the outbound
part (using your terminology). I don't think even using XEN_EVENTFD as proposed
here that that one could send an VIRQ via EVTCHNOP_send (I could be wrong as
it has been a long time).

Regardless, I think you have a good point to split the semantics and (...)

> But... the IRQ routing table isn't really set up for that, and doesn't
> have explicit *deletion*. The kvm_xen_setup_evtchn() function might get
> called to translate into an updated table which is subsequently
> *abandoned*, and it would never know. I suppose we could stash the GSI#
> and then when we want to deliver it we look up that GSI# in the current
> table and see if it's *stale* but that's getting nasty.
> 
> I suppose that's not insurmountable, but the other problem with
> inferring it from *either* the inbound or outbound port# tables is that
> the vCPU might not even *exist* at the time the table is set up (after
> live update or live migration, as the vCPU threads all go off and do
> their thing and *eventually* create their vCPUs, while the machine
> itself is being restored on the main VMM thread.)
> 
> So I think I'm going to make the timer VIRQ (port#, priority) into an
> explicit KVM_XEN_VCPU_ATTR_TYPE. 

(...) thus this makes sense. Do you particularly care about
VIRQ_DEBUG?

> Along with the *actual* timer expiry,
> which we need to extract/restore for LU/LM too, don't we?
> /me nods

I haven't thought that one well for Live Update / Live Migration, but
I wonder if wouldn't be better to be instead a general 'xen state'
attr type should you need more than just pending timers expiry. Albeit
considering that the VMM has everything it needs (?), perhaps for Xen PV
timer look to be the oddball missing, and we donºt need to go that extent.
