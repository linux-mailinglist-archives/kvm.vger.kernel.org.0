Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB13E72A0BC
	for <lists+kvm@lfdr.de>; Fri,  9 Jun 2023 18:57:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbjFIQ5m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Jun 2023 12:57:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbjFIQ5l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Jun 2023 12:57:41 -0400
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 780153A89
        for <kvm@vger.kernel.org>; Fri,  9 Jun 2023 09:57:40 -0700 (PDT)
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 359Bkucn021097;
        Fri, 9 Jun 2023 16:57:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=2mON5YaCpuJiTPHDiQh+dmnmKCyyn5pqG0jrlirOFJ0=;
 b=Ainfx6vszdCsRQWj987y77nPT1VpRo94HI1qd1Y43h2U5aVPciIfNiyIJ9VWe0wJpWZt
 b07zGrohlbwBpMwbUdZvM92jrE5lZ2VGSKprm8Tmjh1Rd0TpUH5+a7thhWsVdW8MwWoB
 gPYQAxYz8YWo7VnzRmTP2U1wjfCHVviJXGox367Lzemd8dqoDOygL6wg4LMvMMiHFiUx
 sKvjpnLY9UEBu16RqhJOCjov3xLYNGS5o+TdVgIcWnGB7ZWaEMgn/2HOvP1kUUnd7ILf
 ve0Gg0ZXq03QnWyR42LLYznG5Ofb22xBtA9KmPmPTRSmKUGTdedsbwjT3YEg3HzLcHPm Qw== 
Received: from nasanppmta03.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3r3vu4hd39-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Jun 2023 16:57:35 +0000
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
        by NASANPPMTA03.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 359GvYrf025700
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 9 Jun 2023 16:57:34 GMT
Received: from [10.110.16.202] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.42; Fri, 9 Jun 2023
 09:57:33 -0700
Message-ID: <bbc0b864-8a5f-50dd-40a2-14a8ae18af3b@quicinc.com>
Date:   Fri, 9 Jun 2023 09:57:33 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [RFC PATCH part-1 0/5] pKVM on Intel Platform Introduction
To:     Dmytro Maluka <dmy@semihalf.com>, Keir Fraser <keirf@google.com>,
        Sean Christopherson <seanjc@google.com>
CC:     Jason Chen CJ <jason.cj.chen@intel.com>, <kvm@vger.kernel.org>,
        <android-kvm@google.com>, Dmitry Torokhov <dtor@chromium.org>,
        Tomasz Nowicki <tn@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>
References: <20230312180048.1778187-1-jason.cj.chen@intel.com>
 <ZA9QZcADubkx/3Ev@google.com> <ZBCeH5JB14Gl3wOM@jiechen-ubuntu-dev>
 <ZBCC3qEPHGWnx2JO@google.com> <ZB17s69rC9ioomF7@google.com>
 <883b7419-b8ac-f16a-e102-d3408c29bbff@semihalf.com>
Content-Language: en-US
From:   Trilok Soni <quic_tsoni@quicinc.com>
In-Reply-To: <883b7419-b8ac-f16a-e102-d3408c29bbff@semihalf.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: u7NRFiCagMJmbzFNQLfD8RF4luKj12Ji
X-Proofpoint-ORIG-GUID: u7NRFiCagMJmbzFNQLfD8RF4luKj12Ji
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-09_12,2023-06-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 priorityscore=1501 clxscore=1011
 suspectscore=0 spamscore=0 mlxscore=0 adultscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306090143
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/8/2023 2:06 PM, Dmytro Maluka wrote:
> On 3/24/23 11:30, Keir Fraser wrote:
>> On Tue, Mar 14, 2023 at 07:21:18AM -0700, Sean Christopherson wrote:
>>> On Tue, Mar 14, 2023, Jason Chen CJ wrote:
>>>> On Mon, Mar 13, 2023 at 09:33:41AM -0700, Sean Christopherson wrote:
>>>>
>>>>> On Mon, Mar 13, 2023, Jason Chen CJ wrote:
>>>>>> There are similar use cases on x86 platforms requesting protected
>>>>>> environment which is isolated from host OS for confidential computing.
>>>>>
>>>>> What exactly are those use cases?  The more details you can provide, the better.
>>>>> E.g. restricting the isolated VMs to 64-bit mode a la TDX would likely simplify
>>>>> the pKVM implementation.
>>>>
>>>> Thanks Sean for your comments, I am very appreciated!
>>>>
>>>> We are expected
>>>
>>> Who is "we"?  Unless Intel is making a rather large pivot, I doubt Intel is the
>>> end customer of pKVM-on-x86.  If you aren't at liberty to say due NDA/confidentiality,
>>> then please work with whoever you need to in order to get permission to fully
>>> disclose the use case.  Because realistically, without knowing exactly what is
>>> in scope and why, this is going nowhere.
>>
>> This is being seriously evaluated by ChromeOS as an alternative to
>> their existing ManaTEE design. Compared with that (hypervisor == full
>> Linux) the pKVM design is pretty attractive: smaller TCB, host Linux
>> "VM" runs closer to native and without nested scheduling, demonstrated
>> better performance, and closer alignment with Android virtualisation
>> (that's my team, which of course is ARM focused, but we'd love to see
>> broader uptake of pKVM in the kernel).
> 
> Right, we (Google with the help of Semihalf and Intel) have been
> evaluating pKVM for ChromeOS on Intel platforms (using this Intel's
> pKVM-on-x86 PoC) as a platform for running secure workloads in VMs
> protected from the untrusted ChromeOS host, and it looks quite promising
> so far, in terms of both performance and design simplicity.
> 
> The primary use cases for those secure workloads on Chromebooks are for
> protection of sensitive biometric data (e.g. fingerprints, face
> authentication), which means that we expect pKVM to provide not just the
> basic memory protection for secure VMs but also protection of secure
> devices assigned to those VMs (e.g. fingerprint sensor, secure camera).


Very interesting usecases. I would be interested to know how you plan to
paravirt the clocks and regulators required for these devices on the 
guest VM (Protected VM) on x86. On ARM, we have SCMI specification w/
virtio-scmi, it is possible to do the clock and regulators paravirt.

Camera may have need more h/w dependencies than clocks and regulators 
like flash LEDs, gpios, IOMMUs, I2C on top of the camera driver pipeline 
itself.

Do you have any proof-of-concept for above usecases to check and 
reproduce on the chrome w/ x86?

Do we have the recording of the PUCK meeting?

---Trilok Soni
