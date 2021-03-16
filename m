Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B66033D0F3
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 10:40:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234156AbhCPJkD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 05:40:03 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:60662 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231278AbhCPJjh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Mar 2021 05:39:37 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12G9YDHk014438
        for <kvm@vger.kernel.org>; Tue, 16 Mar 2021 05:39:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=CHYZu2cbs6yMgtJjrJG0aFbvgAoj/Ty9uQ6jvhuotnY=;
 b=UbhFwqnSzs75ovftYoMJRBzW7KVzA+VJ6b4sAUhHOyt249QlJnjPH3k6NNLC2GvS4Od2
 r+gkLkTSWdunPK+5R/ZK88dz4cb3t13ZkNw0TPpH8UwBOkehC+U20EAVwD3UiuEw411E
 8T9gWDc3jbdt6GdDS3U65m3ia6wCpvt4V2C2Mn85xTD5mlfhP1oi1es/YHxWg0v8tDNG
 vPdsgyiktFreSDjCpZbHfpd7Sg14m5tYJQBLhgK+xoi7xpTeGX+6u59xhw+mQF8Ce+j6
 9qoF4kx1c2/UhI3CcNQBNOguK0BtCHdwmVOruSIbaAzcvmo+LJNizE13RZhqfLjdLk4o ug== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37abcxp6a6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 16 Mar 2021 05:39:36 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12G9akQH024870
        for <kvm@vger.kernel.org>; Tue, 16 Mar 2021 05:39:36 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37abcxp69f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Mar 2021 05:39:36 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12G9T60T002983;
        Tue, 16 Mar 2021 09:39:34 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04fra.de.ibm.com with ESMTP id 378n189dgx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Mar 2021 09:39:34 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12G9dVis36438294
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Mar 2021 09:39:31 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 08EB95204E;
        Tue, 16 Mar 2021 09:39:31 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.149.250])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id BA97C52054;
        Tue, 16 Mar 2021 09:39:30 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v6 0/6] CSS Mesurement Block
To:     Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        imbrenda@linux.ibm.com
References: <1615545714-13747-1-git-send-email-pmorel@linux.ibm.com>
 <20210312121805.4fab030c.cohuck@redhat.com>
 <3e422288-77d5-3869-ba21-64b4fe2f2551@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <e60a8abd-48cb-29fe-ea3f-7b750939f1b0@linux.ibm.com>
Date:   Tue, 16 Mar 2021 10:39:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <3e422288-77d5-3869-ba21-64b4fe2f2551@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-16_03:2021-03-15,2021-03-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 mlxlogscore=998 spamscore=0 impostorscore=0 malwarescore=0 adultscore=0
 mlxscore=0 priorityscore=1501 bulkscore=0 lowpriorityscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103160065
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/12/21 3:17 PM, Janosch Frank wrote:
> On 3/12/21 12:18 PM, Cornelia Huck wrote:
>> On Fri, 12 Mar 2021 11:41:48 +0100
>> Pierre Morel <pmorel@linux.ibm.com> wrote:

...

>> Series looks good to me.
>>
> 
> @Pierre: Could you please push to devel?
> 
> Let's give it a whirl on the CI over the weekend and I'll have another
> look at the patches at Monday before picking.
> 

  pushed this morning, sorry, had vacancies the last 2 days :)


-- 
Pierre Morel
IBM Lab Boeblingen
