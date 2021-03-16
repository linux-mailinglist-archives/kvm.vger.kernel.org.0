Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04F6233D1C3
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 11:27:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235236AbhCPK1S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 06:27:18 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:62854 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230259AbhCPK0p (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Mar 2021 06:26:45 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12GA35mI040661
        for <kvm@vger.kernel.org>; Tue, 16 Mar 2021 06:26:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=iLvt0NRwI9tPL0wtrIs2rCwA14CZL8dJO7O9nH+LS24=;
 b=d6J5sNCDwMWq/5c2yQoNcdTmBRMV9wNHYyfeB8RV4qUGvkCX5oHiqTKxoSyHOMNV1KkX
 vGvFlTcGTDq6JMPA7xd5d3045S8sT60BpQP5nWSxUFUrIpn/e/rLynmHCn9MLx6FtGSX
 gPz5eBdPnDIsEnCla5deYmH67nFShy3HPSxhh7elGrvH1RNJoGY4Tuzvn9ftaYDErIT7
 aGzt3Fba001QFlNs6E7lEiJP/1nD4xHuLD4hwPrROSWlGa2jQinXe0M6D4nA5rMOWjV/
 hZiTqMwR9uH1+zGrcSmaO5qaRPmT7Mek9GZ6I5NA5mMt20WZ/1hSuwzgZuwHLewyoUJS og== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37add33u2g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 16 Mar 2021 06:26:45 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12GA4KD2047559
        for <kvm@vger.kernel.org>; Tue, 16 Mar 2021 06:26:45 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37add33u1v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Mar 2021 06:26:45 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12GAM6ke009588;
        Tue, 16 Mar 2021 10:26:43 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma05fra.de.ibm.com with ESMTP id 378n189ejv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Mar 2021 10:26:42 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12GAQNZ913762858
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Mar 2021 10:26:23 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E87465204E;
        Tue, 16 Mar 2021 10:26:39 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.149.250])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id B250152063;
        Tue, 16 Mar 2021 10:26:39 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v6 3/6] s390x: css: extending the
 subchannel modifying functions
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     david@redhat.com, thuth@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com
References: <1615545714-13747-1-git-send-email-pmorel@linux.ibm.com>
 <1615545714-13747-4-git-send-email-pmorel@linux.ibm.com>
 <e24ced70-5008-e432-95f5-c5862beb9741@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <ea8d0822-204e-bd1f-47a4-e4975cc5ab48@linux.ibm.com>
Date:   Tue, 16 Mar 2021 11:26:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <e24ced70-5008-e432-95f5-c5862beb9741@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-16_03:2021-03-16,2021-03-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 lowpriorityscore=0 spamscore=0 malwarescore=0 suspectscore=0 adultscore=0
 priorityscore=1501 mlxscore=0 mlxlogscore=875 impostorscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103160067
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/15/21 11:50 AM, Janosch Frank wrote:
> On 3/12/21 11:41 AM, Pierre Morel wrote:
>> To enable or disable measurement we will need specific
>> modifications on the subchannel.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> 
> Acked-by: Janosch Frank <frankja@linux.ibm.com>
> 
thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
